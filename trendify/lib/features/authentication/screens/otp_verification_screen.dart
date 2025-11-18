import 'package:flutter/material.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/features/authentication/widgets/auth_styles.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final otpController = TextEditingController();
    return Scaffold(
      backgroundColor: TColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: TSizes.spaceBtwSections),
                Text(
                  TTexts.emailVerificationTitle,
                  style: authHeadingStyle(context),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  TTexts.emailVerificationSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                TextFormField(
                  controller: otpController,
                  decoration: authInputDecoration(
                    hint: TTexts.emailVerificationSubtitle,
                    prefix: Icons.confirmation_number,
                  ),
                  validator: TValidator.validateOTP,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: authButtonStyle(),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    child: const Text(TTexts.emailVerificationContinue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
