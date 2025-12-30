class Feed {
  const Feed({required this.id, required this.name, required this.url});

  Feed copyWith({String? id, String? name, String? url}) {
    return Feed(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }

  final String id;
  final String name;
  final String url;
}
