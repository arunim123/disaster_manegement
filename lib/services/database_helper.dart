import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // sqflite recommends importing path
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

// Model for a news article to be stored in the DB
class NewsArticleDbModel {
  final String guid; // Unique identifier from RSS feed (e.g., item.guid?.value)
  final String title;
  final String? link;
  final String? description;
  final String? pubDate; // Store as ISO8601 string or int (millisecondsSinceEpoch)
  final int fetchedTimestamp; // MillisecondsSinceEpoch when this was fetched

  NewsArticleDbModel({
    required this.guid,
    required this.title,
    this.link,
    this.description,
    this.pubDate,
    required this.fetchedTimestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'guid': guid,
      'title': title,
      'link': link,
      'description': description,
      'pubDate': pubDate,
      'fetchedTimestamp': fetchedTimestamp,
    };
  }

  factory NewsArticleDbModel.fromMap(Map<String, dynamic> map) {
    return NewsArticleDbModel(
      guid: map['guid'] as String,
      title: map['title'] as String,
      link: map['link'] as String?,
      description: map['description'] as String?,
      pubDate: map['pubDate'] as String?,
      fetchedTimestamp: map['fetchedTimestamp'] as int,
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _dbName = 'disaster_app.db';
  static const String _newsTable = 'news_articles';
  static const int _dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_newsTable (
        guid TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        link TEXT,
        description TEXT,
        pubDate TEXT,
        fetchedTimestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertNewsArticles(List<NewsArticleDbModel> articles) async {
    final db = await database;
    Batch batch = db.batch();
    for (var article in articles) {
      batch.insert(
        _newsTable,
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Upsert: replaces if guid exists
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<NewsArticleDbModel>> getNewsArticles({int limit = 50}) async {
    final db = await database;
    // Order by publication date (if available and parseable) or fetched time
    // For simplicity, let's order by fetchedTimestamp first.
    // Proper pubDate ordering would require parsing it to a comparable format.
    final List<Map<String, dynamic>> maps = await db.query(
      _newsTable,
      orderBy: 'fetchedTimestamp DESC', // Show newest fetched first
      // Consider adding pubDate sorting if pubDate is stored as ISO string or epoch
      // orderBy: 'pubDate DESC, fetchedTimestamp DESC' 
      limit: limit,
    );

    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (i) {
      return NewsArticleDbModel.fromMap(maps[i]);
    });
  }
  
  Future<int> getNewsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $_newsTable');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Optional: Clear all news articles
  Future<void> clearNewsArticles() async {
    final db = await database;
    await db.delete(_newsTable);
  }

  // Optional: Clear articles older than a certain period or exceeding a count
  Future<void> pruneNewsArticles({int maxArticles = 100}) async {
    final db = await database;
    final count = await getNewsCount();
    if (count > maxArticles) {
      // Delete the oldest (by fetchedTimestamp) articles to reduce count to maxArticles
      final articlesToDelete = count - maxArticles;
      if (articlesToDelete > 0) {
        // This query finds the 'fetchedTimestamp' of the (maxArticles)th newest article.
        // Then deletes all articles older than or equal to that if we sort ASC, or just limit.
        // Simpler: delete rows with the smallest fetchedTimestamp until count is right.
        // Get IDs of oldest articles
        List<Map<String, dynamic>> oldestArticles = await db.query(
          _newsTable,
          columns: ['guid'],
          orderBy: 'fetchedTimestamp ASC', // Oldest first
          limit: articlesToDelete,
        );
        if (oldestArticles.isNotEmpty) {
          Batch batch = db.batch();
          for (var articleMap in oldestArticles) {
            batch.delete(_newsTable, where: 'guid = ?', whereArgs: [articleMap['guid']]);
          }
          await batch.commit(noResult: true);
        }
      }
    }
  }
} 