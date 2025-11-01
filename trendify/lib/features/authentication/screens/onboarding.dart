import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/image_strings.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:trendify/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> images = [
    TImages.onboardingImage1,
    TImages.onboardingImage2,
    TImages.onboardingImage3,
  ];
  final List<String> titles = [
    TTexts.onboardingTitle1,
    TTexts.onboardingTitle2,
    TTexts.onboardingTitle3,
  ];
  final List<String> subtitles = [
    TTexts.onboardingSubTitle1,
    TTexts.onboardingSubTitle2,
    TTexts.onboardingSubTitle3,
  ];

  void _nextPage() {
    if (_currentPage < images.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to signup page
      Get.offAllNamed(AppRoutes.signup);
    }
  }

  void _skip() {
    _controller.animateToPage(
      images.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(TSizes.defaultSpace),
                    child: TextButton(
                      onPressed: _skip,
                      style: TextButton.styleFrom(
                        foregroundColor: TColors.primary,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              images[index],
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            SizedBox(height: TSizes.spaceBtwItems),
                            Text(
                              titles[index],
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: TSizes.spaceBtwItems),
                            Text(
                              subtitles[index],
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Navigation Dots
                Padding(
                  padding: EdgeInsets.only(top: TSizes.spaceBtwItems),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: images.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: TColors.primary,
                      dotColor: TColors.accent,
                    ),
                  ),
                ),
                // Next Button
                Padding(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == images.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
