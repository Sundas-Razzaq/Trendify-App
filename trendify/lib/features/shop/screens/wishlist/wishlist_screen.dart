import 'package:flutter/material.dart';
import 'package:trendify/features/shop/shop_services/cart_wishlist_store.dart';
import 'package:trendify/features/shop/screens/products/product_card.dart';
import 'package:trendify/features/shop/models/product.dart';
import 'package:trendify/utils/constants/sizes.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Product>>(
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
                    product: p,
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
