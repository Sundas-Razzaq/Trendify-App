import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/image_strings.dart';
import 'package:trendify/features/shop/screens/products/product_card.dart';
import 'package:trendify/features/shop/screens/products/product_data.dart';
import 'package:trendify/features/shop/services/cart_wishlist_store.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final PageController _pageController = PageController(viewportFraction: 0.98);
  late Timer _timer;
  int _currentPage = 0;

  final List<String> _banners = [
    TImages.productImage1,
    TImages.productImage2,
    TImages.productImage3,
    TImages.productImage4,
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && _banners.isNotEmpty) {
        _currentPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCarousel(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final img = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (c, e, st) =>
                        Container(color: TColors.softGrey),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: TSizes.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == i ? 10 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? TColors.primary
                    : TColors.darkGrey.withAlpha((0.2 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _productRow(String title, String category, {bool accented = false}) {
    final products = ProductData.getProductsByCategory(category);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final itemWidth = maxWidth * 0.45 < 200 ? maxWidth * 0.45 : 200.0;
        final rowHeight = itemWidth * 1.6;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              child: Row(
                children: [
                  if (accented)
                    Container(
                      width: 8,
                      height: 28,
                      margin: const EdgeInsets.only(right: TSizes.sm),
                      decoration: BoxDecoration(
                        color: TColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('View All')),
                ],
              ),
            ),
            const SizedBox(height: TSizes.sm),

            /// ⭐ Responsive Horizontal Product List — No overflow now
            SizedBox(
              height: rowHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];

                  return SizedBox(
                    width: itemWidth,
                    child: ProductCard(
                      imagePath: p['image'] as String,
                      title: p['title'] as String,
                      subtitle: p['subtitle'] as String?,
                      price: (p['price'] as num).toDouble(),
                      onAddToCart: () {
                        CartWishlistStore.instance.addToCart(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      },
                      onFavoriteTap: () {
                        CartWishlistStore.instance.addToWishlist(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to wishlist')),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: TSizes.sm),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: TSizes.sm),
          _buildCarousel(context),
          const SizedBox(height: TSizes.md),

          _productRow("Trending Now", "Beauty", accented: false),
          const SizedBox(height: TSizes.md),

          _productRow("Best Sellers", "Fashion", accented: true),
          const SizedBox(height: TSizes.md),
        ],
      ),
    );
  }
}
