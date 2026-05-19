import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_plus/webfeed_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ai_service.dart';

class NewsUpdatesScreen extends StatefulWidget {
  const NewsUpdatesScreen({super.key});

  @override
  State<NewsUpdatesScreen> createState() => _NewsUpdatesScreenState();
}

class _NewsUpdatesScreenState extends State<NewsUpdatesScreen> {
  final String _feedUrl = 'https://news.google.com/rss/search?q=disaster+OR+earthquake+OR+flood+india&hl=en-IN&gl=IN&ceid=IN:en';
  RssFeed? _feed;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final prefs = await SharedPreferences.getInstance();
    
    try {
      final response = await http.get(Uri.parse(_feedUrl)).timeout(const Duration(seconds: 10));
      if (mounted) { 
        if (response.statusCode == 200) {
          try {
            _feed = RssFeed.parse(response.body);
            // Cache the successful XML string
            await prefs.setString('cached_news_feed', response.body);
          } catch (e) {
            _errorMessage = 'Error parsing feed content.';
          }
        } else {
          _errorMessage = 'Failed to load RSS feed: Status code ${response.statusCode}';
          await _loadCachedNews(prefs);
        }
      }
    } catch (e) {
      if (mounted) {
        // Network error, try to load cache
        await _loadCachedNews(prefs);
        if (_feed == null) {
           _errorMessage = 'No internet connection and no cached news available.';
        } else {
           // We have cached news, clear error to show the cached list
           _errorMessage = null;
           ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Offline mode: Showing cached news.')),
           );
        }
      }
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCachedNews(SharedPreferences prefs) async {
    final cachedXml = prefs.getString('cached_news_feed');
    if (cachedXml != null) {
      try {
        _feed = RssFeed.parse(cachedXml);
      } catch (e) {
        _feed = null;
      }
    }
  }

  Future<void> _launchUrl(BuildContext context, String? urlString) async {
    if (urlString == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No link available for this item.')),
        );
      }
      return;
    }
    final Uri? uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster News (India)'),
        actions: [
          Semantics(
            label: 'Refresh news feed button',
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchNews,
              tooltip: 'Refresh Feed',
            ),
          )
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: _feed != null && _feed!.items != null && _feed!.items!.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _summarizeNewsWithAi,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Summarize AI'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Future<void> _summarizeNewsWithAi() async {
    if (_feed == null || _feed!.items == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.deepOrange),
            SizedBox(width: 8),
            Text('AI Summary'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing latest updates...'),
          ],
        ),
      ),
    );

    final items = _feed!.items!.take(5).map((e) => '${e.title}: ${e.description ?? ""}').toList();
    final summary = await AiService.summarizeNews(items);

    if (mounted) {
      Navigator.pop(context); // close loading dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.deepOrange),
              SizedBox(width: 8),
              Text('AI Summary'),
            ],
          ),
          content: Text(summary),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red[700], fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                onPressed: _fetchNews,
              )
            ],
          )
        ),
      );
    }
    if (_feed == null || _feed!.items == null || _feed!.items!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No news items found or failed to load feed.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              onPressed: _fetchNews,
            )
          ],
        )
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchNews,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _feed!.items!.length,
        itemBuilder: (context, index) {
          final item = _feed!.items![index];
          final title = item.title ?? 'No Title';
          final description = item.description?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                              item.pubDate?.toString() ??
                              'No Description';

          return Semantics(
            label: 'News article: $title. Tap to read more.',
            button: true,
            child: Card(
              child: ListTile(
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.open_in_new, color: Theme.of(context).colorScheme.primary),
                onTap: () => _launchUrl(context, item.link),
              ),
            ),
          );
        },
      ),
    );
  }
} 