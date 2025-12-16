import 'package:flutter/material.dart';
import 'package:trendify/features/shop/shop_services/cart_wishlist_store.dart';
import 'package:trendify/features/shop/screens/products/product_card.dart';
import 'package:trendify/features/shop/models/product.dart';
import 'package:trendify/utils/constants/sizes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Product>>(
      valueListenable: CartWishlistStore.instance.cart,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
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
                product: p,
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
