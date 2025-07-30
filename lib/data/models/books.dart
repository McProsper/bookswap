class Book {
  final String id;
  final String title;
  final String author;
  final String level;
  final String condition;
  final String imageUrl;
  final String systeme;
  // final String? classe;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.level,
    required this.condition,
    required this.imageUrl,
    required this.systeme,
    // this.classe,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'] ?? 'Inconnu',
      level: json['level'],
      condition: json['condition'],
      imageUrl: json['imageUrl'],
      systeme: json['systeme'] ?? '',
      // classe: json['classe'],
    );
  }
}