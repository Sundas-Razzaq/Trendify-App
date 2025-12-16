import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:trendify/features/shop/models/product.dart';

class ProductService {
  ProductService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _products =>
      _db.collection('products');

  Future<void> addProduct(Product product) async {
    final data = Map<String, dynamic>.from(product.toMap())..remove('id');
    // If image is a local data uri or filename, we expect caller to upload and set product.image
    await _products.add(data);
  }

  /// Returns a stream of products filtered by [category]. Category should be
  /// provided as a lowercase key (e.g. 'men', 'women', 'kids').
  Stream<List<Product>> getProductsByCategory(String category) {
    return _products
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Product.fromFirestore(doc)).toList(),
        );
  }

  Stream<List<Product>> getProducts() {
    return _products.snapshots().map(
      (snap) => snap.docs.map((doc) => Product.fromFirestore(doc)).toList(),
    );
  }

  Future<void> updateProduct(Product product) async {
    final id = product.id;
    if (id == null || id.isEmpty) {
      throw ArgumentError.value(
        id,
        'product.id',
        'Product id is required for update',
      );
    }
    final data = Map<String, dynamic>.from(product.toMap())..remove('id');
    await _products.doc(id).update(data);
  }

  Future<void> deleteProduct(String productId) async {
    await _products.doc(productId).delete();
  }
}
