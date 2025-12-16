import 'package:flutter/foundation.dart';
import 'package:trendify/features/shop/models/product.dart';

/// Simple in-memory store for wishlist and cart items.
class CartWishlistStore {
  CartWishlistStore._();

  static final CartWishlistStore instance = CartWishlistStore._();

  // Store Product objects instead of raw maps.
  final ValueNotifier<List<Product>> wishlist = ValueNotifier([]);
  final ValueNotifier<List<Product>> cart = ValueNotifier([]);

  void addToWishlist(Product product) {
    final already = wishlist.value.any((p) => p.title == product.title);
    if (!already) {
      wishlist.value = List.from(wishlist.value)..add(product);
    }
  }

  void addToCart(Product product) {
    final already = cart.value.any((p) => p.title == product.title);
    if (!already) {
      cart.value = List.from(cart.value)..add(product);
    }
  }

  void removeFromWishlist(Product product) {
    wishlist.value = List.from(wishlist.value)
      ..removeWhere((p) => p.title == product.title);
  }

  void removeFromCart(Product product) {
    cart.value = List.from(cart.value)
      ..removeWhere((p) => p.title == product.title);
  }
}
