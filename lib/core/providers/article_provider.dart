import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

import '../models/article.dart';
import '../models/feed.dart';

class ArticleProvider extends ChangeNotifier {
  ArticleProvider({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  bool _isLoading = false;
  String? _error;
  List<Article> _articles = const [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Article> get articles => _articles;

  Future<void> fetchArticles(List<Feed> feeds) async {
    _setLoading(true);
    try {
      if (feeds.isEmpty) {
        _articles = const [];
        _error = 'No RSS feeds configured';
        return;
      }

      final results = await Future.wait(feeds.map(_fetchFeedItems));
      final combined = results.expand((items) => items).toList()
        ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      _articles = combined;
      _error = null;
    } catch (error) {
      _error = error.toString();
      _articles = const [];
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Article>> _fetchFeedItems(Feed feed) async {
    try {
      final response = await _httpClient.get(Uri.parse(feed.url));
      if (response.statusCode != 200) return [];

      final document = xml.XmlDocument.parse(response.body);
      final items = document.findAllElements('item');
      final articles = <Article>[];

      for (final item in items) {
        final pubDateRaw = _readChildText(item, 'pubDate');
        if (pubDateRaw == null) continue;
        final publishedAt = _parsePubDate(pubDateRaw);
        if (publishedAt == null) continue;

        final title = _readChildText(item, 'title') ?? 'Untitled';
        final link = _readChildText(item, 'link') ?? '';
        if (link.isEmpty) continue;

        final descriptionHtml =
            _readChildText(item, 'description') ?? _readChildText(item, 'content:encoded') ?? '';
        final imageUrl = _extractImageUrl(descriptionHtml);
        final summary = _stripHtml(descriptionHtml);

        final categories = item
            .findElements('category')
            .map((element) => element.innerText.trim())
            .where((text) => text.isNotEmpty)
            .toList();
        final category = categories.isEmpty ? null : categories.join(', ');

        final subItem = ArticleSubItem(
          title: summary.isNotEmpty ? summary : title,
          url: link,
          source: feed.name,
          imageUrl: imageUrl,
        );

        articles.add(
          Article(
            title: title,
            summary: summary,
            publishedAt: publishedAt,
            link: link,
            source: feed.name,
            category: category,
            imageUrl: imageUrl,
            subItems: [subItem],
          ),
        );
      }

      return articles;
    } catch (_) {
      return [];
    }
  }

  String? _readChildText(xml.XmlElement element, String name) {
    final matches = element.findElements(name);
    if (matches.isEmpty) return null;
    final value = matches.first.innerText.trim();
    return value.isEmpty ? null : value;
  }

  DateTime? _parsePubDate(String raw) {
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso.toLocal();

    for (final format in _rssDateFormats) {
      try {
        return format.parseUtc(raw).toLocal();
      } catch (_) {
        try {
          return format.parse(raw, true).toLocal();
        } catch (_) {
          continue;
        }
      }
    }
    return null;
  }

  String? _extractImageUrl(String html) {
    final match = _imageRegex.firstMatch(html);
    return match?.group(1);
  }

  String _stripHtml(String input) {
    if (input.isEmpty) return '';
    final withoutTags = input.replaceAll(_htmlTagRegex, ' ');
    return withoutTags.replaceAll(_whitespaceRegex, ' ').trim();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  static final _imageRegex = RegExp(r'<img[^>]+src="([^">]+)"', caseSensitive: false);
  static final _htmlTagRegex = RegExp(r'<[^>]*>', multiLine: true);
  static final _whitespaceRegex = RegExp(r'\s+');
  static final _rssDateFormats = [
    DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US'),
    DateFormat('EEE, d MMM yyyy HH:mm:ss Z', 'en_US'),
    DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz', 'en_US'),
    DateFormat('EEE, d MMM yyyy HH:mm:ss zzz', 'en_US'),
    DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'"),
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"),
  ];
}
