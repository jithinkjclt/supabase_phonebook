class Contact {
  final String id;
  final String name;
  final String phone;
  final bool isFavorite;
  final DateTime createdAt;

  const Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.isFavorite,
    required this.createdAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      isFavorite: json['is_favorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Contact copyWith({String? name, String? phone, bool? isFavorite}) {
    return Contact(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
    );
  }
}
