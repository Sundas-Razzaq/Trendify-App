import 'package:flutter/foundation.dart';

/// Simple in-memory store for wishlist and cart items.
class CartWishlistStore {
  CartWishlistStore._();

  static final CartWishlistStore instance = CartWishlistStore._();

  // Each item is stored as a Map<String, dynamic> matching product_data entries.
  final ValueNotifier<List<Map<String, dynamic>>> wishlist = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> cart = ValueNotifier([]);

  void addToWishlist(Map<String, dynamic> product) {
    final already = wishlist.value.any((p) => p['title'] == product['title']);
    if (!already) {
      wishlist.value = List.from(wishlist.value)..add(product);
    }
  }

  void addToCart(Map<String, dynamic> product) {
    final already = cart.value.any((p) => p['title'] == product['title']);
    if (!already) {
      cart.value = List.from(cart.value)..add(product);
    }
  }

  void removeFromWishlist(Map<String, dynamic> product) {
    wishlist.value = List.from(wishlist.value)
      ..removeWhere((p) => p['title'] == product['title']);
  }

  void removeFromCart(Map<String, dynamic> product) {
    cart.value = List.from(cart.value)
      ..removeWhere((p) => p['title'] == product['title']);
  }
}
