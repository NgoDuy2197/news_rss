import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/article_provider.dart';
import '../../../core/providers/feed_provider.dart';
import '../../../l10n/app_localizations.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchLatestArticles();
      if (mounted) _startAutoRefresh();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      _fetchLatestArticles();
    });
  }

  Future<void> _fetchLatestArticles({bool forceFeedRefresh = false}) async {
    final feedProvider = context.read<FeedProvider>();
    if (feedProvider.feeds.isEmpty || forceFeedRefresh) {
      await feedProvider.loadFeeds(forceRefresh: true);
    }
    await context.read<ArticleProvider>().fetchArticles(feedProvider.feeds);
  }

  Future<void> _handleRefresh() async {
    await _fetchLatestArticles(forceFeedRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer2<ArticleProvider, FeedProvider>(
      builder: (context, articleProvider, feedProvider, _) {
        if (articleProvider.isLoading && articleProvider.articles.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final hasFeeds = feedProvider.feeds.isNotEmpty;
        final articles = articleProvider.articles;
        final emptyMessage = !hasFeeds
            ? l10n.feedsEmpty
            : (articleProvider.error ?? l10n.articlesEmpty);

        return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              if (articles.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: Text(
                      emptyMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              }
              final article = articles[index];
              final subItem = article.subItems.isNotEmpty ? article.subItems.first : null;
              final summary = article.summary.isNotEmpty
                  ? article.summary
                  : (subItem?.title ?? '');
              final publishedText = DateFormat.yMMMd().add_Hm().format(article.publishedAt);

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              article.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      if (article.imageUrl != null) const SizedBox(height: 12),
                      Text(
                        article.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(publishedText),
                          const SizedBox(width: 12),
                          const Icon(Icons.rss_feed, size: 16),
                          const SizedBox(width: 6),
                          Flexible(child: Text(article.source)),
                        ],
                      ),
                      if (article.category != null) ...[
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(article.category!),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        summary,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (subItem != null) ...[
                        const SizedBox(height: 12),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            title: Text(subItem.title),
                            subtitle: Text(subItem.source),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openArticle(subItem.url),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: articles.isEmpty ? 1 : articles.length,
          ),
        );
      },
    );
  }

  void _openArticle(String url) {
    // TODO: integrate url_launcher once deep links are defined.
  }
}
