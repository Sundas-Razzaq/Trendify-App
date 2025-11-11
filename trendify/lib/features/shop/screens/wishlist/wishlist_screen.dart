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
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determine crossAxisCount responsively
              int crossAxisCount = 2;
              final width = constraints.maxWidth;
              if (width > 1100) {
                crossAxisCount = 5;
              } else if (width > 900) {
                crossAxisCount = 4;
              } else if (width > 600) {
                crossAxisCount = 3;
              }

              final horizontalPadding = TSizes.md * 2;
              final cardWidth =
                  (width -
                      (crossAxisCount - 1) * TSizes.gridViewSpacing -
                      horizontalPadding) /
                  crossAxisCount;
              final childAspectRatio = cardWidth / (cardWidth * 1.6);

              return GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
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
              );
            },
          ),
        );
      },
    );
  }
}
