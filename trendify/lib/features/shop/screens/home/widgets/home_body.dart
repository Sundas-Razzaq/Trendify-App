import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/image_strings.dart';
import 'package:trendify/features/shop/screens/products/product_card.dart';
// import 'package:trendify/features/shop/screens/products/product_data.dart';
import 'package:trendify/utils/services/product_service.dart';
import 'package:trendify/features/shop/models/product.dart';
import 'package:trendify/features/shop/shop_services/cart_wishlist_store.dart';
import 'package:trendify/features/shop/screens/products/product_details.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final PageController _pageController = PageController(viewportFraction: 0.98);
  final ProductService _productService = ProductService();
  late Timer _timer;
  int _currentPage = 0;

  final List<String> _banners = [TImages.bannerImage1, TImages.bannerImage2];

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

  // ============================
  // BANNER CAROUSEL SECTION
  // ============================
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

  // ============================
  // FEATURED OFFER BANNER SECTION
  // ============================
  Widget _buildFeaturedOffer() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.lg,
        vertical: TSizes.xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColors.primary.withAlpha((0.9 * 255).toInt()),
            TColors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "50-40% OFF",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: TSizes.xs),
              Text(
                "Now we provide a full answer.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha((0.9 * 255).toInt()),
                ),
              ),
              const SizedBox(height: TSizes.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.lg,
                  vertical: TSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                ),
                child: Text(
                  "Shop Now →",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TColors.primary,
                  ),
                ),
              ),
            ],
          ),
          // You can add an image here if needed
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2 * 255).toInt()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_offer_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // SPECIAL OFFERS SECTION
  // ============================
  Widget _buildSpecialOffers() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      padding: const EdgeInsets.all(TSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[100]!, Colors.orange[50]!],
        ),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Special Offers",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: TSizes.xs),
                Text(
                  "We make sure you get the offer you need at best prices.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700]!.withAlpha((0.8 * 255).toInt()),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: TSizes.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.md,
                    vertical: TSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[800],
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                  ),
                  child: Text(
                    "Visit now →",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TSizes.md),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange[800]!.withAlpha((0.2 * 255).toInt()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard,
              color: Colors.orange[800],
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // PRODUCT ROW SECTION
  // ============================
  Widget _productRow(String title, String category, {bool accented = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final itemWidth = maxWidth * 0.45 < 200 ? maxWidth * 0.45 : 200.0;
        final rowHeight = itemWidth * 1.6;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                child: Row(
                  children: [
                    if (accented)
                      Container(
                        width: 4,
                        height: 20,
                        margin: const EdgeInsets.only(right: TSizes.sm),
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: TColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.sm),

              // Product List
              SizedBox(
                height: rowHeight,
                child: StreamBuilder<List<Product>>(
                  stream: _productService.getProductsByCategory(
                    category.toLowerCase(),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final products = snapshot.data ?? <Product>[];

                    if (products.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.md,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final p = products[index];

                        return SizedBox(
                          width: itemWidth,
                          child: ProductCard(
                            product: p,
                            onAddToCart: () {
                              CartWishlistStore.instance.addToCart(p);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to cart')),
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsPage(
                                    categoryName: category,
                                    product: p,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: TSizes.sm),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================
  // SUMMER SALES BANNER SECTION
  // ============================
  Widget _buildSummerSales() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      padding: const EdgeInsets.all(TSizes.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[50]!, Colors.blue[100]!],
        ),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SUMMER SALES",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: TSizes.xs),
              Text(
                "New Arrivals\nSummer '25 Collections",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.lg,
              vertical: TSizes.md,
            ),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            ),
            child: Column(
              children: [
                Text(
                  "UP TO",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "50%",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "OFF",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

          // Banner Carousel
          _buildCarousel(context),
          const SizedBox(height: TSizes.md),

          // Featured Offer Section
          _buildFeaturedOffer(),
          const SizedBox(height: TSizes.md),

          // Trending Products
          _productRow("Trending Products", "Beauty", accented: false),
          const SizedBox(height: TSizes.md),

          // Special Offers Section
          _buildSpecialOffers(),
          const SizedBox(height: TSizes.md),

          // Best Sellers
          _productRow("Best Sellers", "Fashion", accented: true),
          const SizedBox(height: TSizes.md),

          // Summer Sales Banner
          _buildSummerSales(),
          const SizedBox(height: TSizes.lg),
        ],
      ),
    );
  }
}
