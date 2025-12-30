import 'package:flutter/material.dart';

enum AppThemeStyle { classic, rosy }

class AppThemeProvider extends ChangeNotifier {
  AppThemeStyle _current = AppThemeStyle.classic;

  AppThemeStyle get current => _current;

  ThemeData get themeData => switch (_current) {
        AppThemeStyle.classic => ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), useMaterial3: true),
        AppThemeStyle.rosy => ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFE91E63),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFFFF6FA),
              textTheme: Typography().black.apply(bodyColor: const Color(0xFF57243C)),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFFE91E63),
                foregroundColor: Colors.white,
              ),
            ),
      };

  void setTheme(AppThemeStyle style) {
    if (_current == style) return;
    _current = style;
    notifyListeners();
  }
}
