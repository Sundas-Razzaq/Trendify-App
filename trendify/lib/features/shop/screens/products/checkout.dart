import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/features/shop/models/order.dart';
import 'package:trendify/features/shop/models/product.dart';
import 'package:trendify/features/shop/shop_services/orders_store.dart';
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
                  // Create a simple order and add to store
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  final items = <Map<String, dynamic>>[];
                  double total = 0.0;
                  if (product != null) {
                    items.add(product.toMap());
                    total = product.price;
                  }

                  final order = Order(
                    id: id,
                    items: items,
                    total: total,
                    date: DateTime.now(),
                  );
                  OrdersStore().addOrder(order);

                  // show confirmation dialog then navigate to Orders screen
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
