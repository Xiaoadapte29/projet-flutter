import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  double amount;
  String type; 
  String description;
  String categoryId;
  DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.categoryId,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> data, String docId) {
    return TransactionModel(
      id: docId,
      amount: (data['amount'] as num).toDouble(),
      type: data['type'],
      description: data['description'],
      categoryId: data['categoryId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'description': description,
      'categoryId': categoryId,
      'createdAt': createdAt,
    };
  }
}
