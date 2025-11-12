import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';

class PlaceOrderPage extends StatelessWidget {
  const PlaceOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final product = args['product'] as Map<String, dynamic>?;
    final category = args['category'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Place Order')),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product != null) ...[
              Text(
                product['title'] ?? '',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.sm),
              Text('Category: $category'),
              const SizedBox(height: TSizes.md),
            ],

            const Text('Order summary and shipping details would go here.'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Proceed to checkout
                  Get.toNamed('/checkout', arguments: {'product': product});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                ),
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
