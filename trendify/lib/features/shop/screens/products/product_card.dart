import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/features/shop/models/product.dart';
import 'package:trendify/routes/app_routes.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;
  final double? width;
  final bool showBuyNow;

  const ProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onAddToCart,
    this.onTap,
    this.width,
    this.showBuyNow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// IMAGE + FAVORITE
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Builder(
                      builder: (context) {
                        final img = product.image;
                        if (img.startsWith('http')) {
                          return Image.network(
                            img,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: TColors.softGrey,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white70,
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        // Fallback to asset if path exists, otherwise placeholder
                        try {
                          return Image.asset(
                            img,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: TColors.softGrey,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                          );
                        } catch (_) {
                          return Container(
                            color: TColors.softGrey,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.white70,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  Positioned(
                    top: TSizes.sm,
                    right: TSizes.sm,
                    child: Material(
                      color: Colors.black26,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onFavoriteTap,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? TColors.primary : Colors.white,
                            size: TSizes.iconMd,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// CONTENT
              Padding(
                padding: const EdgeInsets.all(TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: TSizes.fontSizeMd,
                        color: TColors.textprimary,
                      ),
                    ),

                    /// SUBTITLE
                    if (product.subtitle != null) ...[
                      const SizedBox(height: TSizes.xs),
                      Text(
                        product.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: TColors.darkGrey,
                        ),
                      ),
                    ],

                    const SizedBox(height: TSizes.sm),

                    /// PRICE
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: TSizes.sm),
                        if (product.oldPrice != null)
                          Text(
                            '\$${product.oldPrice!.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: TColors.darkGrey,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: TSizes.sm),

                    /// RATING
                    if (product.rating != null)
                      Row(
                        children: [
                          // show up to 5 stars filled according to rating
                          ...List.generate(5, (i) {
                            final filled = (product.rating ?? 0) >= (i + 1);
                            return Icon(
                              filled ? Icons.star : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            );
                          }),
                          const SizedBox(width: TSizes.xs),
                          Text(
                            product.rating!.toStringAsFixed(1),
                            style: theme.textTheme.bodySmall,
                          ),
                          if (product.reviews != null)
                            Text(
                              ' (${product.reviews})',
                              style: theme.textTheme.bodySmall,
                            ),
                        ],
                      ),

                    const SizedBox(height: TSizes.sm),

                    /// ADD TO CART
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onAddToCart,
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: TSizes.xs,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TSizes.buttonRadius,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// BUY NOW
                    if (showBuyNow) ...[
                      const SizedBox(height: TSizes.xs),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Direct to checkout with single product
                            Get.toNamed(
                              AppRoutes.checkout,
                              arguments: {'product': product},
                            );
                          },
                          icon: const Icon(Icons.flash_on, size: 18),
                          label: const Text('Buy Now'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: TColors.primary,
                            side: const BorderSide(color: TColors.primary),
                            padding: const EdgeInsets.symmetric(
                              vertical: TSizes.xs,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                TSizes.buttonRadius,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
