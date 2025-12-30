import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class AppLanguageProvider extends ChangeNotifier {
  AppLanguageProvider();

  Locale _locale = AppLocalizations.supportedLocales.first;

  Locale get locale => _locale;
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  void changeLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) {
      return;
    }
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}
