import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'News Control Center'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Access Workspace'**
  String get loginButton;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember session'**
  String get rememberMe;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign in. Please try again.'**
  String get loginError;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Functions'**
  String get menuTitle;

  /// No description provided for @menuArticles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get menuArticles;

  /// No description provided for @menuAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get menuAlerts;

  /// No description provided for @menuFeeds.
  ///
  /// In en, this message translates to:
  /// **'Feeds'**
  String get menuFeeds;

  /// No description provided for @articlesHeader.
  ///
  /// In en, this message translates to:
  /// **'Latest Articles'**
  String get articlesHeader;

  /// No description provided for @articlesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No articles available.'**
  String get articlesEmpty;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @alertsHeader.
  ///
  /// In en, this message translates to:
  /// **'System Alerts'**
  String get alertsHeader;

  /// No description provided for @triggerAlert.
  ///
  /// In en, this message translates to:
  /// **'Trigger Alert'**
  String get triggerAlert;

  /// No description provided for @alertDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Important Notice'**
  String get alertDialogTitle;

  /// No description provided for @alertDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Server maintenance is scheduled soon.'**
  String get alertDialogBody;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeClassic.
  ///
  /// In en, this message translates to:
  /// **'Indigo pulse'**
  String get themeClassic;

  /// No description provided for @themePink.
  ///
  /// In en, this message translates to:
  /// **'Rosy bloom'**
  String get themePink;

  /// No description provided for @loginHint.
  ///
  /// In en, this message translates to:
  /// **'Secure access required before using features'**
  String get loginHint;

  /// No description provided for @notifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get notifySuccess;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace chat'**
  String get chatTitle;

  /// No description provided for @chatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Share a note with the team...'**
  String get chatPlaceholder;

  /// No description provided for @chatAssistantName.
  ///
  /// In en, this message translates to:
  /// **'Ops assistant'**
  String get chatAssistantName;

  /// No description provided for @chatWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Let me know if you need anything.'**
  String get chatWelcome;

  /// No description provided for @chatAutoReply.
  ///
  /// In en, this message translates to:
  /// **'Got it! I\'ll watch over that.'**
  String get chatAutoReply;

  /// No description provided for @chatUserName.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get chatUserName;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @feedsHeader.
  ///
  /// In en, this message translates to:
  /// **'Feed management'**
  String get feedsHeader;

  /// No description provided for @feedsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No feeds yet. Create one to start syncing.'**
  String get feedsEmpty;

  /// No description provided for @addFeed.
  ///
  /// In en, this message translates to:
  /// **'Add feed'**
  String get addFeed;

  /// No description provided for @editFeed.
  ///
  /// In en, this message translates to:
  /// **'Edit feed'**
  String get editFeed;

  /// No description provided for @deleteFeed.
  ///
  /// In en, this message translates to:
  /// **'Delete feed'**
  String get deleteFeed;

  /// No description provided for @feedName.
  ///
  /// In en, this message translates to:
  /// **'Feed name'**
  String get feedName;

  /// No description provided for @feedUrl.
  ///
  /// In en, this message translates to:
  /// **'Feed URL'**
  String get feedUrl;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove feed?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This feed will be removed from the workspace.'**
  String get deleteConfirmMessage;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @feedCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Feed created'**
  String get feedCreateSuccess;

  /// No description provided for @feedUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Feed updated'**
  String get feedUpdateSuccess;

  /// No description provided for @feedDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Feed removed'**
  String get feedDeleteSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
