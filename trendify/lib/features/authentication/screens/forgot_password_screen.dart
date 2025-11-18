import 'package:flutter/material.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/features/authentication/widgets/auth_styles.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
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
                Text('Forgot password?', style: authHeadingStyle(context)),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'Enter your email to receive reset instructions',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                TextFormField(
                  controller: emailController,
                  decoration: authInputDecoration(
                    hint: TTexts.resetPasswordEmailLabel,
                    prefix: Icons.email,
                  ),
                  validator: TValidator.validateEmail,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: authButtonStyle(),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/reset-password',
                        );
                      }
                    },
                    child: const Text(TTexts.resetPasswordButton),
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
