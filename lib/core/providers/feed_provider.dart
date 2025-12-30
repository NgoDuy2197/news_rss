import 'dart:convert';

import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../models/api_result.dart';
import '../models/feed.dart';
import '../services/api_client.dart';

class FeedProvider extends ChangeNotifier {
  FeedProvider({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  bool _isLoading = false;
  List<Feed> _feeds = const [];

  bool get isLoading => _isLoading;
  List<Feed> get feeds => List.unmodifiable(_feeds);

  Future<void> loadFeeds({bool forceRefresh = false}) async {
    if (_feeds.isNotEmpty && !forceRefresh) return;
    _setLoading(true);
    try {
      if (AppConfig.instance.useMockApi) {
        await Future.delayed(const Duration(milliseconds: 350));
        _feeds = _sampleFeeds;
      } else {
        final result = await _apiClient.get<List<Feed>>(
          '/feeds',
          parser: (body) {
            if (body is List) {
              return body
                  .map((item) => Feed.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
            throw Exception('Invalid feed response');
          },
        );
        if (result.success && result.data != null) {
          _feeds = result.data!;
        } else {
          throw Exception(result.message ?? 'Unable to load feeds');
        }
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<ApiResult<Feed>> createFeed({required String name, required String url}) async {
    _setLoading(true);
    try {
      if (AppConfig.instance.useMockApi) {
        await Future.delayed(const Duration(milliseconds: 320));
        final newFeed = Feed(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          url: url,
        );
        _feeds = [..._feeds, newFeed];
        return ApiResult(success: true, data: newFeed);
      }
      final payload = jsonEncode({'name': name, 'url': url});
      final result = await _apiClient.post<Map<String, dynamic>>(
        '/feeds',
        body: payload,
        parser: (body) => body as Map<String, dynamic>,
      );
      if (result.success && result.data != null) {
        final feed = Feed.fromJson(result.data!);
        _feeds = [..._feeds, feed];
        return ApiResult(success: true, data: feed);
      }
      return ApiResult(success: false, message: result.message);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<ApiResult<Feed>> updateFeed(Feed feed) async {
    _setLoading(true);
    try {
      if (AppConfig.instance.useMockApi) {
        await Future.delayed(const Duration(milliseconds: 300));
        _feeds = _feeds.map((item) => item.id == feed.id ? feed : item).toList();
        return ApiResult(success: true, data: feed);
      }
      final payload = jsonEncode(feed.toJson());
      final result = await _apiClient.post<Map<String, dynamic>>(
        '/feeds/${feed.id}',
        body: payload,
        parser: (body) => body as Map<String, dynamic>,
      );
      if (result.success && result.data != null) {
        final updated = Feed.fromJson(result.data!);
        _feeds = _feeds.map((item) => item.id == updated.id ? updated : item).toList();
        return ApiResult(success: true, data: updated);
      }
      return ApiResult(success: false, message: result.message);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<ApiResult<void>> deleteFeed(String id) async {
    _setLoading(true);
    try {
      if (AppConfig.instance.useMockApi) {
        await Future.delayed(const Duration(milliseconds: 280));
        _feeds = _feeds.where((feed) => feed.id != id).toList();
        return const ApiResult(success: true);
      }
      final result = await _apiClient.post<void>(
        '/feeds/$id/delete',
        parser: (_) {},
      );
      if (result.success) {
        _feeds = _feeds.where((feed) => feed.id != id).toList();
        return const ApiResult(success: true);
      }
      return ApiResult(success: false, message: result.message);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Feed> get _sampleFeeds => const [
        Feed(id: 'alpha', name: 'Global Tech', url: 'https://sample.dev/rss/tech'),
        Feed(id: 'beta', name: 'Finance Daily', url: 'https://sample.dev/rss/finance'),
      ];
}
