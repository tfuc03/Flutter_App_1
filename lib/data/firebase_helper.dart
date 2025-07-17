import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static final FirebaseHelper _instance = FirebaseHelper._internal();
  factory FirebaseHelper() => _instance;
  FirebaseHelper._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get categoriesCollection =>
      _firestore.collection('categories');
  CollectionReference get productsCollection =>
      _firestore.collection('products');

  // Category operations
  Future<String> insertCategory(Map<String, dynamic> data) async {
    try {
      DocumentReference doc = await categoriesCollection.add(data);
      return doc.id;
    } catch (e) {
      throw Exception('Lỗi khi thêm danh mục: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      QuerySnapshot snapshot = await categoriesCollection.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách danh mục: $e');
    }
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    try {
      await categoriesCollection.doc(id).update(data);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật danh mục: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      // Delete all products in this category first
      QuerySnapshot products =
          await productsCollection.where('categoryId', isEqualTo: id).get();

      for (QueryDocumentSnapshot product in products.docs) {
        await product.reference.delete();
      }

      // Then delete the category
      await categoriesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa danh mục: $e');
    }
  }

  // Product operations
  Future<String> insertProduct(Map<String, dynamic> data) async {
    try {
      DocumentReference doc = await productsCollection.add(data);
      return doc.id;
    } catch (e) {
      throw Exception('Lỗi khi thêm sản phẩm: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      QuerySnapshot snapshot = await productsCollection.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách sản phẩm: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(
    String categoryId,
  ) async {
    try {
      QuerySnapshot snapshot =
          await productsCollection
              .where('categoryId', isEqualTo: categoryId)
              .get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy sản phẩm theo danh mục: $e');
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      await productsCollection.doc(id).update(data);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật sản phẩm: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await productsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa sản phẩm: $e');
    }
  }

  // Stream operations for real-time updates
  Stream<List<Map<String, dynamic>>> getCategoriesStream() {
    return categoriesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getProductsStream() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}
