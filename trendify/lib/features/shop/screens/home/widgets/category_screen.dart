import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/common/widgets/navigation/trendy_bottom_nav.dart';
import 'package:trendify/features/shop/screens/main_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(categoryName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: TColors.textprimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  hintText: 'Search in $categoryName',
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

              // Placeholder for product list/cards
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  color: TColors.softGrey.withAlpha(51),
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Products will appear here',
                      style: TextStyle(
                        fontSize: TSizes.fontSizeMd,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: TSizes.sm),
                    // TODO: Add product cards/grid here
                    SizedBox(height: 200),
                  ],
                ),
              ),
            ],
          ),
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
