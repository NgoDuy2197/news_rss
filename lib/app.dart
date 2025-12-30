import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_config.dart';
import 'core/providers/app_language_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/app_theme_provider.dart';
import 'core/providers/article_provider.dart';
import 'core/providers/feed_provider.dart';
import 'core/services/api_client.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_shell.dart';
import 'l10n/app_localizations.dart';

class NewsRssApp extends StatelessWidget {
  const NewsRssApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<AppLanguageProvider>(
          create: (_) => AppLanguageProvider(),
        ),
        ChangeNotifierProvider<AppThemeProvider>(
          create: (_) => AppThemeProvider(),
        ),
        ChangeNotifierProvider<ArticleProvider>(
          create: (_) => ArticleProvider(),
        ),
        ChangeNotifierProvider<FeedProvider>(
          create: (_) => FeedProvider(apiClient: ApiClient()),
        ),
      ],
      child: Consumer2<AppLanguageProvider, AppThemeProvider>(
        builder: (context, languageProvider, themeProvider, _) {
          return MaterialApp(
            title: AppConfig.instance.appTitle,
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            locale: languageProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const _AuthGate(),
          );
        },
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const DashboardShell();
        }
        return const LoginScreen();
      },
    );
  }
}
