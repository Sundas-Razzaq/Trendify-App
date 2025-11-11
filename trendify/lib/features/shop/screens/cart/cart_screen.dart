import 'package:flutter/material.dart';
import 'package:trendify/features/shop/services/cart_wishlist_store.dart';
import 'package:trendify/features/shop/screens/products/product_card.dart';
import 'package:trendify/utils/constants/sizes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: CartWishlistStore.instance.cart,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }

        return Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: TSizes.sm),
            itemBuilder: (context, index) {
              final p = items[index];
              return ProductCard(
                imagePath: p['image'] as String,
                title: p['title'] as String,
                subtitle: p['subtitle'] as String?,
                price: (p['price'] as num).toDouble(),
                oldPrice: p['oldPrice'] != null
                    ? (p['oldPrice'] as num).toDouble()
                    : null,
                onFavoriteTap: () {
                  CartWishlistStore.instance.addToWishlist(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to wishlist')),
                  );
                },
                onAddToCart: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Already in cart')),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
