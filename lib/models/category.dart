import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String id;
  String name;
  String description;
  DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory Category.fromMap(Map<String, dynamic> data, String docId) {
    return Category(
      id: docId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
