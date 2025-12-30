import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_language_provider.dart';
import '../../core/providers/app_theme_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import 'screens/alerts_screen.dart';
import 'screens/articles_screen.dart';
import 'screens/feeds_screen.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;

  final _tabs = const [
    _DashboardDestination(icon: Icons.article_outlined, labelKey: 'menuArticles'),
    _DashboardDestination(icon: Icons.rss_feed, labelKey: 'menuFeeds'),
    _DashboardDestination(icon: Icons.notifications_active_outlined, labelKey: 'menuAlerts'),
  ];

  void _openChatSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ChatSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = context.watch<AppLanguageProvider>();
    final themeProvider = context.watch<AppThemeProvider>();
    final isWide = MediaQuery.of(context).size.width >= 900;

    final chatButton = FloatingActionButton.extended(
      onPressed: () => _openChatSheet(context),
      icon: const Icon(Icons.chat_bubble_outline),
      label: Text(l10n.chatTitle),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          _LanguageSwitcher(provider: languageProvider),
          _ThemeSwitcher(themeProvider: themeProvider),
          const SizedBox(width: 8),
          IconButton(
            tooltip: l10n.logout,
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton:
          isWide ? chatButton : Padding(padding: const EdgeInsets.only(bottom: 72), child: chatButton),
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  extended: true,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  destinations: _tabs
                      .map(
                        (tab) => NavigationRailDestination(
                          icon: Icon(tab.icon),
                          label: Text(l10n._resolve(tab.labelKey)),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: _DashboardContent(index: _selectedIndex)),
              ],
            )
          : Column(
              children: [
                Expanded(child: _DashboardContent(index: _selectedIndex)),
                NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  destinations: _tabs
                      .map(
                        (tab) => NavigationDestination(
                          icon: Icon(tab.icon),
                          label: l10n._resolve(tab.labelKey),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
    );
  }
}

class _DashboardDestination {
  const _DashboardDestination({required this.icon, required this.labelKey});

  final IconData icon;
  final String labelKey;
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return const ArticlesScreen();
      case 1:
        return const FeedsScreen();
      case 2:
        return const AlertsScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher({required this.provider});

  final AppLanguageProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Tooltip(
      message: l10n.language,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: provider.locale,
          onChanged: (locale) {
            if (locale == null) return;
            provider.changeLocale(locale);
          },
          items: provider.supportedLocales
              .map(
                (locale) => DropdownMenuItem(
                  value: locale,
                  child: Text(locale.languageCode.toUpperCase()),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ThemeSwitcher extends StatelessWidget {
  const _ThemeSwitcher({required this.themeProvider});

  final AppThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<AppThemeStyle>(
      tooltip: l10n.themeTitle,
      icon: const Icon(Icons.palette_outlined),
      initialValue: themeProvider.current,
      onSelected: themeProvider.setTheme,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppThemeStyle.classic,
          child: Text(l10n.themeClassic),
        ),
        PopupMenuItem(
          value: AppThemeStyle.rosy,
          child: Text(l10n.themePink),
        ),
      ],
    );
  }
}

class _ChatSheet extends StatefulWidget {
  const _ChatSheet();

  @override
  State<_ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends State<_ChatSheet> {
  final _textController = TextEditingController();
  final List<_ChatMessage> _messages = [];
  bool _didAddWelcome = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didAddWelcome) return;
    final l10n = AppLocalizations.of(context)!;
    _messages.add(_ChatMessage(isUser: false, text: l10n.chatWelcome, timestamp: DateTime.now()));
    _didAddWelcome = true;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: text, timestamp: DateTime.now()));
    });
    _textController.clear();
    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() {
      _messages.add(
        _ChatMessage(isUser: false, text: l10n.chatAutoReply, timestamp: DateTime.now()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 48,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.chatTitle, style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text(l10n.chatAssistantName),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                reverse: false,
                shrinkWrap: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final alignment =
                      message.isUser ? Alignment.centerRight : Alignment.centerLeft;
                  final color = message.isUser
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest;
                  final author = message.isUser ? l10n.chatUserName : l10n.chatAssistantName;
                  return Align(
                    alignment: alignment,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            author,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(message.text),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: l10n.chatPlaceholder,
                      border: const OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _sendMessage,
                  child: Text(l10n.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  _ChatMessage({required this.isUser, required this.text, required this.timestamp});

  final bool isUser;
  final String text;
  final DateTime timestamp;
}

extension on AppLocalizations {
  String _resolve(String key) {
    switch (key) {
      case 'menuArticles':
        return menuArticles;
      case 'menuAlerts':
        return menuAlerts;
      case 'menuFeeds':
        return menuFeeds;
      default:
        return key;
    }
  }
}
