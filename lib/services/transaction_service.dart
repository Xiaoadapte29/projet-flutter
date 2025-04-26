import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';

class TransactionService {
  final _txRef = FirebaseFirestore.instance.collection('transactions');

  Future<void> addTransaction(TransactionModel tx) {
    return _txRef.add(tx.toMap());
  }

  Stream<List<TransactionModel>> getTransactions() {
    return _txRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<double> getTotal(String type) async {
    final snapshot = await _txRef.where('type', isEqualTo: type).get();
    return snapshot.docs.fold<double>(
      0.0,
      (sum, doc) => sum + (doc['amount'] as num).toDouble(),
    );
  }
}
