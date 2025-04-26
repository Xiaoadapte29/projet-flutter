import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  final _categoryRef = FirebaseFirestore.instance.collection('categories');

  Future<void> addCategory(Category category) {
    return _categoryRef.add(category.toMap());
  }

  Stream<List<Category>> getCategories() {
    return _categoryRef.orderBy('createdAt').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
