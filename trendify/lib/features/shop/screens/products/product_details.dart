import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/common/widgets/navigation/trendy_bottom_nav.dart';
import 'package:trendify/features/shop/shop_services/cart_wishlist_store.dart';
import 'package:trendify/features/shop/models/product.dart';
// import 'package:trendify/features/shop/screens/products/product_card.dart';

class ProductDetailsPage extends StatelessWidget {
  final String categoryName;
  final Product product;

  const ProductDetailsPage({
    super.key,
    required this.categoryName,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(product.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: TColors.textprimary,
        actions: [
          IconButton(
            onPressed: () {
              // open cart
              Navigator.pushReplacementNamed(context, '/cart');
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image: use an AspectRatio so image scales across screen sizes
            ClipRRect(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, st) => Container(
                    color: TColors.softGrey,
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: TSizes.md),

            // Title and subtitle
            Text(
              product.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (product.subtitle != null) ...[
              const SizedBox(height: TSizes.xs),
              Text(product.subtitle!, style: theme.textTheme.bodyMedium),
            ],

            const SizedBox(height: TSizes.sm),

            // Price row
            Row(
              children: [
                Text(
                  '\$${product.price.toDouble().toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: TColors.primary,
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                if (product.oldPrice != null)
                  Text(
                    '\$${product.oldPrice!.toDouble().toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: TSizes.md),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      CartWishlistStore.instance.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      CartWishlistStore.instance.addToWishlist(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to wishlist')),
                      );
                    },
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Wishlist'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.sm),
            // Buy Now -> go to place order screen
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to place order with product info
                  Get.toNamed(
                    '/place-order',
                    arguments: {'product': product, 'category': categoryName},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                ),
                child: const Text('Buy Now'),
              ),
            ),

            const SizedBox(height: TSizes.md),

            // Details heading
            Text('Product Details', style: theme.textTheme.titleMedium),
            const SizedBox(height: TSizes.xs),
            Text(
              product.description ??
                  'This is a demo product description. Replace with real product details from your backend or data model.',
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: TSizes.md),
          ],
        ),
      ),
      bottomNavigationBar: TrendyBottomNav(
        selectedIndex: 0,
        onTabTapped: (i) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SizedBox()),
          );
        },
      ),
    );
  }
}
