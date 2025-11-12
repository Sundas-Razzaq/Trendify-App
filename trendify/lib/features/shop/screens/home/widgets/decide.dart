import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendify/utils/constants/image_strings.dart';
import 'package:trendify/routes/app_routes.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';

class DecideScreen extends StatelessWidget {
  const DecideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            TImages.decide,
            fit: BoxFit.cover,
            errorBuilder: (c, e, st) => const SizedBox.shrink(),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              child: Column(
                children: [
                  const Spacer(),

                  /// ✅ Customer button (filled style)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            TSizes.buttonRadius,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.home);
                      },
                      child: const Text(
                        'Customer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: TSizes.md),

                  /// ✅ Seller button (same style as Customer)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            TSizes.buttonRadius,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // Open the seller main panel which includes appbar, drawer and bottom nav
                        Get.offAllNamed(AppRoutes.sellerMain);
                      },
                      child: const Text(
                        'Seller',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
