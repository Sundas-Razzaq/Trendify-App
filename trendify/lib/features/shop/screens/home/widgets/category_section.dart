import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/image_strings.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'Beauty', 'image': TImages.categoryImage1},
      {'label': 'Fashion', 'image': TImages.categoryImage2},
      {'label': 'Kids', 'image': TImages.categoryImage3},
      {'label': 'Home', 'image': TImages.categoryImage4},
      {'label': 'Mens', 'image': TImages.categoryImage5},
      {'label': 'Womens', 'image': TImages.categoryImage6},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Search Bar Section (full width)
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.md,
            vertical: TSizes.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search any product...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: TSizes.md,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        TSizes.borderRadiusLg,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: TColors.softGrey,
                  ),
                  style: const TextStyle(fontSize: TSizes.fontSizeMd),
                ),
              ),
            ],
          ),
        ),

        // 2. Header Row (title + optional actions)
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.md,
            vertical: TSizes.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Featured',
                style: TextStyle(
                  fontSize: TSizes.fontSizeLg,
                  fontWeight: FontWeight.bold,
                  color: TColors.textprimary,
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.filter_list, color: TColors.textprimary),
                  SizedBox(width: TSizes.sm),
                  Icon(Icons.sort, color: TColors.textprimary),
                ],
              ),
            ],
          ),
        ),

        // 3. Horizontal categories list
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.md,
              vertical: TSizes.sm,
            ),
            itemCount: categories.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: TSizes.spaceBtwItems),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return SizedBox(
                width: 72,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: TColors.softGrey,
                        border: Border.all(
                          color: TColors.borderPrimary,
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          cat['image'] as String,
                          fit: BoxFit.cover,
                          // Show a visible fallback and log if the asset fails to load.
                          errorBuilder: (context, error, stackTrace) {
                            // ignore: avoid_print
                            print(
                              'Failed to load asset: ${cat['image']} -> $error',
                            );
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: SizedBox(
                        width: 64,
                        child: Text(
                          cat['label'] as String,
                          style: const TextStyle(
                            fontSize: TSizes.fontSizeSm,
                            fontWeight: FontWeight.w500,
                            color: TColors.textprimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
