import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_plus/webfeed_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsUpdatesScreen extends StatefulWidget {
  const NewsUpdatesScreen({super.key});

  @override
  State<NewsUpdatesScreen> createState() => _NewsUpdatesScreenState();
}

class _NewsUpdatesScreenState extends State<NewsUpdatesScreen> {
  final String _feedUrl = 'https://www.fema.gov/feeds/news_releases.rss';
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
    try {
      final response = await http.get(Uri.parse(_feedUrl));
      if (mounted) { // Ensure mounted before further setState calls
        if (response.statusCode == 200) {
          print('News Feed Response Body: ${response.body.substring(0, (response.body.length < 500) ? response.body.length : 500)}...'); // Log first 500 chars or less
          try {
            _feed = RssFeed.parse(response.body);
          } catch (e) {
            print('Error parsing RSS feed: $e');
            _errorMessage = 'Error parsing feed content.';
          }
        } else {
          print('Failed to load RSS feed. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          _errorMessage = 'Failed to load RSS feed: Status code ${response.statusCode}';
        }
      }
    } catch (e) {
      if (mounted) {
        _errorMessage = 'Error fetching or parsing feed: ${e.toString()}';
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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
        title: const Text('FEMA News Releases'),
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
    );
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