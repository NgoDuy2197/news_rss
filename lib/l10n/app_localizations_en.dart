// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'News Control Center';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Access Workspace';

  @override
  String get logout => 'Sign out';

  @override
  String get rememberMe => 'Remember session';

  @override
  String get loginError => 'Unable to sign in. Please try again.';

  @override
  String get menuTitle => 'Functions';

  @override
  String get menuArticles => 'Articles';

  @override
  String get menuAlerts => 'Alerts';

  @override
  String get menuFeeds => 'Feeds';

  @override
  String get articlesHeader => 'Latest Articles';

  @override
  String get articlesEmpty => 'No articles available.';

  @override
  String get refresh => 'Refresh';

  @override
  String get alertsHeader => 'System Alerts';

  @override
  String get triggerAlert => 'Trigger Alert';

  @override
  String get alertDialogTitle => 'Important Notice';

  @override
  String get alertDialogBody => 'Server maintenance is scheduled soon.';

  @override
  String get close => 'Close';

  @override
  String get language => 'Language';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeClassic => 'Indigo pulse';

  @override
  String get themePink => 'Rosy bloom';

  @override
  String get loginHint => 'Secure access required before using features';

  @override
  String get notifySuccess => 'Updated successfully';

  @override
  String get chatTitle => 'Workspace chat';

  @override
  String get chatPlaceholder => 'Share a note with the team...';

  @override
  String get chatAssistantName => 'Ops assistant';

  @override
  String get chatWelcome => 'Welcome back! Let me know if you need anything.';

  @override
  String get chatAutoReply => 'Got it! I\'ll watch over that.';

  @override
  String get chatUserName => 'You';

  @override
  String get send => 'Send';

  @override
  String get feedsHeader => 'Feed management';

  @override
  String get feedsEmpty => 'No feeds yet. Create one to start syncing.';

  @override
  String get addFeed => 'Add feed';

  @override
  String get editFeed => 'Edit feed';

  @override
  String get deleteFeed => 'Delete feed';

  @override
  String get feedName => 'Feed name';

  @override
  String get feedUrl => 'Feed URL';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteConfirmTitle => 'Remove feed?';

  @override
  String get deleteConfirmMessage =>
      'This feed will be removed from the workspace.';

  @override
  String get deleteAction => 'Delete';

  @override
  String get feedCreateSuccess => 'Feed created';

  @override
  String get feedUpdateSuccess => 'Feed updated';

  @override
  String get feedDeleteSuccess => 'Feed removed';
}
