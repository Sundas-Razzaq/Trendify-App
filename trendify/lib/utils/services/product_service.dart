import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trendify/features/shop/models/product.dart';

class ProductService {
  final FirebaseFirestore _db;

  ProductService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products =>
      _db.collection('products');

  /// ✅ ADD PRODUCT
  Future<void> addProduct(Product product) async {
    final docRef = _products.doc();
    await docRef
        .set(product.toMap())
        .timeout(
          const Duration(seconds: 20),
          onTimeout: () => throw Exception('Firestore add timeout'),
        );
  }

  /// ✅ UPDATE PRODUCT
  Future<void> updateProduct(Product product) async {
    if (product.id == null || product.id!.isEmpty) {
      throw Exception('Product ID missing for update');
    }

    await _products
        .doc(product.id)
        .update(product.toMap())
        .timeout(
          const Duration(seconds: 20),
          onTimeout: () => throw Exception('Firestore update timeout'),
        );
  }

  /// ✅ DELETE PRODUCT
  Future<void> deleteProduct(String productId) async {
    await _products.doc(productId).delete();
  }

  /// ✅ GET ALL PRODUCTS
  Stream<List<Product>> getProducts() {
    return _products.snapshots().map(
      (snap) => snap.docs.map(Product.fromFirestore).toList(),
    );
  }

  /// ✅ GET PRODUCTS BY CATEGORY (REQUIRED BY category.dart)
  Stream<List<Product>> getProductsByCategory(String category) {
    return _products
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snap) => snap.docs.map(Product.fromFirestore).toList());
  }
}
