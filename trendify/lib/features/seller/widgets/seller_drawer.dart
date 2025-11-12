import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/image_strings.dart';
import 'package:trendify/routes/app_routes.dart';

class SellerDrawer extends StatelessWidget {
  const SellerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with profile picture
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
                  // Seller Profile Picture
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: AssetImage(TImages.appLogo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Seller Name',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'seller@example.com',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),
            const Divider(),

            _drawerTile(
              context,
              Icons.dashboard,
              'Dashboard',
              AppRoutes.sellerMain,
            ),
            _drawerTile(
              context,
              Icons.add,
              'Add Product',
              AppRoutes.sellerAddProduct,
            ),
            _drawerTile(
              context,
              Icons.inventory,
              'Manage Products',
              AppRoutes.sellerManageProducts,
            ),
            _drawerTile(
              context,
              Icons.receipt_long,
              'Orders',
              AppRoutes.sellerOrders,
            ),
            _drawerTile(
              context,
              Icons.store,
              'Inventory',
              AppRoutes.sellerInventory,
            ),
            _drawerTile(
              context,
              Icons.reviews,
              'Reviews',
              AppRoutes.sellerReviews,
            ),
            _drawerTile(
              context,
              Icons.settings,
              'Settings',
              AppRoutes.settings,
            ),

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
        Navigator.pop(context);
        if (routeName != null && routeName.isNotEmpty) {
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }
}
