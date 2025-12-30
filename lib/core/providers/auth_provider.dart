import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/api_result.dart';
import '../services/api_client.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;

  Future<ApiResult<void>> login(String email, String password) async {
    _setLoading(true);
    try {
      final payload = jsonEncode({'email': email, 'password': password});
      // final result = await _apiClient.post<Map<String, dynamic>>(
      //   '/auth/login',
      //   body: payload,
      //   parser: (body) => body as Map<String, dynamic>,
      // );

      final result = {
        "success": true,
        "data": "FAKE_TOKEN",
        "message": "It's OK"
      };

      if (result['success'] == true) {
        _token = result['data'] as String? ?? 'sample-token';
        _isAuthenticated = true;
        notifyListeners();
        return const ApiResult(success: true);
      }
      return ApiResult(success: false, message: result['message'] as String);
    } catch (error) {
      return ApiResult(success: false, message: error.toString());
    } finally {
      _setLoading(false);
    }
  }

  void logout() {
    _isAuthenticated = false;
    _token = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
