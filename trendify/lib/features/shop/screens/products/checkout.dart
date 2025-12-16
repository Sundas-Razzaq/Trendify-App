import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/features/shop/models/order.dart';
import 'package:trendify/features/shop/models/product.dart';
import 'package:trendify/features/shop/shop_services/orders_store.dart';
import 'package:trendify/features/shop/shop_services/cart_wishlist_store.dart';
import 'package:trendify/utils/services/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendify/routes/app_routes.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final product = args['product'] as Product?;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product != null) ...[
              Text(
                'Purchasing: ${product.title}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.md),
            ],
            const Text(
              'Payment method selection and order confirmation would appear here.',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // If a single product was passed, create one order as before.
                  // If no product passed, use the cart store and create one
                  // order per seller by grouping items by `sellerId`.
                  final buyerId = FirebaseAuth.instance.currentUser?.uid;

                  if (product != null) {
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    final items = <Map<String, dynamic>>[product.toMap()];
                    final total = product.price;

                    final order = Order(
                      id: id,
                      buyerId: buyerId,
                      sellerId: product.sellerId,
                      items: items,
                      total: total,
                      date: DateTime.now(),
                    );

                    OrdersStore().addOrder(order);
                    try {
                      await OrderService().addOrder(order);
                    } catch (e) {
                      // Persist failure should not crash UX; log for diagnostics
                      // (keep in-memory order so app behavior remains unchanged)
                      debugPrint('Failed to persist order to Firestore: $e');
                    }

                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Order placed'),
                        content: const Text(
                          'Your order has been placed successfully.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );

                    Get.offAllNamed(AppRoutes.orders);
                    return;
                  }

                  // Use cart items
                  final cartItems = CartWishlistStore.instance.cart.value;
                  if (cartItems.isEmpty) return;

                  // Group products by sellerId (null sellerId grouped under '')
                  final Map<String, List<Product>> bySeller = {};
                  for (final p in cartItems) {
                    final key = p.sellerId ?? '';
                    bySeller.putIfAbsent(key, () => []).add(p);
                  }

                  // Create an order per seller
                  for (final entry in bySeller.entries) {
                    final sellerKey = entry.key.isEmpty ? null : entry.key;
                    final products = entry.value;
                    final items = products.map((p) => p.toMap()).toList();
                    final total = products.fold<double>(
                      0.0,
                      (s, e) => s + e.price,
                    );
                    final id =
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        (sellerKey ?? '');

                    final order = Order(
                      id: id,
                      buyerId: buyerId,
                      sellerId: sellerKey,
                      items: items,
                      total: total,
                      date: DateTime.now(),
                    );

                    OrdersStore().addOrder(order);
                    try {
                      await OrderService().addOrder(order);
                    } catch (e) {
                      debugPrint('Failed to persist order to Firestore: $e');
                    }
                  }

                  // clear cart
                  CartWishlistStore.instance.cart.value = [];

                  await showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Order placed'),
                      content: const Text(
                        'Your order(s) have been placed successfully.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );

                  Get.offAllNamed(AppRoutes.orders);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                ),
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
