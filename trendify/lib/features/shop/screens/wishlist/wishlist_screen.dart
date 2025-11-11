import 'package:flutter/material.dart';
import 'package:trendify/features/shop/services/cart_wishlist_store.dart';
import 'package:trendify/features/shop/screens/products/product_card.dart';
import 'package:trendify/utils/constants/sizes.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: CartWishlistStore.instance.wishlist,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return const Center(child: Text('Your wishlist is empty'));
        }

        return Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: TSizes.gridViewSpacing,
              mainAxisSpacing: TSizes.gridViewSpacing,
            ),
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
                onAddToCart: () {
                  CartWishlistStore.instance.addToCart(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                },
                onFavoriteTap: () {
                  CartWishlistStore.instance.removeFromWishlist(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Removed from wishlist')),
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
