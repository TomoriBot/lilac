class News {
  final int id;
  final String title;
  final String description;
  final String iconUrl;
  final String createdAt;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.createdAt
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        iconUrl: json['icon_url'],
        createdAt: json['created_at']);
  }
}
