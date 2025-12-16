import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/common/widgets/navigation/trendy_bottom_nav.dart';
import 'package:trendify/features/shop/screens/main_screen.dart';
import 'package:trendify/features/shop/screens/products/product_card.dart';
import 'package:trendify/features/shop/screens/products/product_details.dart';
import 'package:trendify/features/shop/shop_services/cart_wishlist_store.dart';
// import 'package:trendify/features/shop/screens/products/product_data.dart';
import 'package:trendify/utils/services/product_service.dart';
import 'package:trendify/features/shop/models/product.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryLabel;
  final String categoryValue;
  const CategoryScreen({
    super.key,
    required this.categoryLabel,
    required this.categoryValue,
  });

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(categoryLabel),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: TColors.textprimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md,
          vertical: TSizes.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search in $categoryLabel',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: TSizes.md,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: TColors.softGrey,
              ),
            ),

            const SizedBox(height: TSizes.sm),

            // Sort & Filter Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sort),
                    label: const Text('Sort'),
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.md),

            // Grid of products
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: productService.getProductsByCategory(
                  categoryValue.toLowerCase(),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final products = snapshot.data ?? <Product>[];

                  if (products.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int crossAxisCount = 2;
                      if (width > 1200) {
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
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: TSizes.gridViewSpacing,
                          crossAxisSpacing: TSizes.gridViewSpacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          final p = products[index];
                          return ProductCard(
                            product: p,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsPage(
                                    categoryName: categoryLabel,
                                    product: p,
                                  ),
                                ),
                              );
                            },
                            onFavoriteTap: () {
                              CartWishlistStore.instance.addToWishlist(p);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to wishlist'),
                                ),
                              );
                            },
                            onAddToCart: () {
                              CartWishlistStore.instance.addToCart(p);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to cart')),
                              );
                            },
                          );
                        },
                        padding: const EdgeInsets.only(bottom: TSizes.md),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TrendyBottomNav(
        selectedIndex: 0,
        onTabTapped: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(initialIndex: index),
            ),
          );
        },
      ),
    );
  }
}
