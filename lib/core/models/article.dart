class Article {
  const Article({
    required this.title,
    required this.summary,
    required this.publishedAt,
    required this.link,
    required this.source,
    this.category,
    this.imageUrl,
    required this.subItems,
  });

  final String title;
  final String summary;
  final DateTime publishedAt;
  final String link;
  final String source;
  final String? category;
  final String? imageUrl;
  final List<ArticleSubItem> subItems;
}

class ArticleSubItem {
  const ArticleSubItem({
    required this.title,
    required this.url,
    required this.source,
    this.imageUrl,
  });

  final String title;
  final String url;
  final String source;
  final String? imageUrl;
}
