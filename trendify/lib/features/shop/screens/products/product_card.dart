import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? subtitle;
  final double price;
  final double? oldPrice;
  final double? rating;
  final int? reviewsCount;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCart;
  final double? width;

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.subtitle,
    required this.price,
    this.oldPrice,
    this.rating,
    this.reviewsCount,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onAddToCart,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image with optional favorite button overlay
          Stack(
            children: [
              // Image
              AspectRatio(
                aspectRatio: 3 / 2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(TSizes.cardRadiusMd),
                    topRight: Radius.circular(TSizes.cardRadiusMd),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // ignore: avoid_print
                      print('ProductCard: failed to load $imagePath -> $error');
                      return Container(
                        color: TColors.softGrey,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Favorite button
              Positioned(
                right: TSizes.sm,
                top: TSizes.sm,
                child: Material(
                  color: Colors.black26,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onFavoriteTap,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
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

          // Content
          Padding(
            padding: const EdgeInsets.all(TSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: TSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                    color: TColors.textprimary,
                  ),
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: TSizes.xs),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: TColors.darkGrey,
                    ),
                  ),
                ],

                const SizedBox(height: TSizes.sm),

                // Price and old price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: TSizes.fontSizeMd,
                        color: TColors.textprimary,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    if (oldPrice != null)
                      Text(
                        '\$${oldPrice!.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: TColors.darkGrey,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: TSizes.sm),

                // Rating and reviews
                if (rating != null || reviewsCount != null)
                  Row(
                    children: [
                      if (rating != null) ...[
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: TSizes.xs),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (reviewsCount != null) ...[
                        const SizedBox(width: TSizes.xs),
                        Text(
                          '(${reviewsCount.toString()})',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),

                const SizedBox(height: TSizes.sm),

                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                      backgroundColor: TColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          TSizes.buttonRadius,
                        ),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
