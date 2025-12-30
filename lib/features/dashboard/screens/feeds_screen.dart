import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/feed.dart';
import '../../../core/providers/feed_provider.dart';
import '../../../core/utils/notification_helper.dart';
import '../../../l10n/app_localizations.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadFeeds();
    });
  }

  Future<void> _openForm({Feed? feed}) async {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<FeedProvider>();
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: feed?.name ?? '');
    final urlController = TextEditingController(text: feed?.url ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(feed == null ? l10n.addFeed : l10n.editFeed),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.feedName),
                  validator: (value) =>
                      value != null && value.trim().isNotEmpty ? null : l10n.feedName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: urlController,
                  decoration: InputDecoration(labelText: l10n.feedUrl),
                  validator: (value) => value != null && value.startsWith('http')
                      ? null
                      : l10n.feedUrl,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(context, true);
                if (feed == null) {
                  final response = await provider.createFeed(
                    name: nameController.text.trim(),
                    url: urlController.text.trim(),
                  );
                  if (response.success && mounted) {
                    NotificationHelper.showSnack(
                      context,
                      message: l10n.feedCreateSuccess,
                    );
                  }
                } else {
                  final response = await provider.updateFeed(
                    feed.copyWith(
                      name: nameController.text.trim(),
                      url: urlController.text.trim(),
                    ),
                  );
                  if (response.success && mounted) {
                    NotificationHelper.showSnack(
                      context,
                      message: l10n.feedUpdateSuccess,
                    );
                  }
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    urlController.dispose();

    if (result != true) return;
    await provider.loadFeeds(forceRefresh: true);
  }

  Future<void> _confirmDelete(Feed feed) async {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<FeedProvider>();
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteAction),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;
    final result = await provider.deleteFeed(feed.id);
    if (result.success && mounted) {
      NotificationHelper.showSnack(context, message: l10n.feedDeleteSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<FeedProvider>(
      builder: (context, provider, _) {
        return RefreshIndicator(
          onRefresh: () => provider.loadFeeds(forceRefresh: true),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.feedsHeader,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider.feeds.isEmpty
                                ? l10n.feedsEmpty
                                : '${provider.feeds.length} feeds synced',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: () => _openForm(),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.addFeed),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.isLoading && provider.feeds.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.feeds.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      l10n.feedsEmpty,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) {
                      final feed = provider.feeds[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          title: Text(feed.name),
                          subtitle: Text(feed.url),
                          leading: const Icon(Icons.rss_feed),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                tooltip: l10n.editFeed,
                                icon: const Icon(Icons.edit),
                                onPressed: () => _openForm(feed: feed),
                              ),
                              IconButton(
                                tooltip: l10n.deleteFeed,
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _confirmDelete(feed),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: provider.feeds.length,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
