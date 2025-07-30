class Supply {
  final String id;
  final String name;
  final String type;

  Supply({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Supply.fromJson(Map<String, dynamic> json) {
    return Supply(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
    );
  }
}