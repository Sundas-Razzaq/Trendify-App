import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/image_strings.dart';
import 'package:trendify/routes/app_routes.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.defaultSpace,
                vertical: TSizes.defaultSpace * 1.5,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  // App Logo
                  Image.asset(TImages.appLogo, height: 40),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  // Profile Avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            const Divider(),
            // Navigation List Tiles
            _drawerTile(context, Icons.home, 'Home', AppRoutes.home),
            _drawerTile(
              context,
              Icons.favorite,
              'Wishlist',
              AppRoutes.wishlist,
            ),
            _drawerTile(
              context,
              Icons.shopping_bag,
              'Orders',
              AppRoutes.orders,
            ),
            _drawerTile(
              context,
              Icons.settings,
              'Settings',
              AppRoutes.settings,
            ),
            _drawerTile(context, Icons.help_outline, 'Help & Support'),
            const SizedBox(height: TSizes.spaceBtwSections),
            _drawerTile(context, Icons.logout, 'Logout', AppRoutes.logout),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(
    BuildContext context,
    IconData icon,
    String label, [
    String? routeName,
  ]) {
    return ListTile(
      leading: Icon(icon, color: TColors.primary),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: TColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer first
        if (routeName != null && routeName.isNotEmpty) {
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }
}
