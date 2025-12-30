import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../models/api_result.dart';

class ApiClient {
  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('${AppConfig.instance.apiBaseUrl}/$normalizedPath');
  }

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, String>? headers,
    required T Function(dynamic body) parser,
  }) async {
    try {
      final response = await _httpClient
          .get(_buildUri(path), headers: headers)
          .timeout(AppConfig.instance.requestTimeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        return ApiResult(success: true, data: parser(decoded));
      }
      return ApiResult(success: false, message: 'Server error: ${response.statusCode}');
    } catch (error) {
      return ApiResult(success: false, message: error.toString());
    }
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    Map<String, String>? headers,
    Object? body,
    required T Function(dynamic body) parser,
  }) async {
    try {
      final mergedHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };
      final response = await _httpClient
          .post(_buildUri(path), headers: mergedHeaders, body: body)
          .timeout(AppConfig.instance.requestTimeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        return ApiResult(success: true, data: parser(decoded));
      }
      return ApiResult(success: false, message: 'Server error: ${response.statusCode}');
    } catch (error) {
      return ApiResult(success: false, message: error.toString());
    }
  }
}
