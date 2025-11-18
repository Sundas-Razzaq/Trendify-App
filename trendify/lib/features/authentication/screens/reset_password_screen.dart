import 'package:flutter/material.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/features/authentication/widgets/auth_styles.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
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
                Text('Reset password', style: authHeadingStyle(context)),
                const SizedBox(height: TSizes.spaceBtwItems),

                TextFormField(
                  controller: passwordController,
                  decoration: authInputDecoration(
                    hint: TTexts.signupPasswordLabel,
                    prefix: Icons.lock,
                  ),
                  obscureText: true,
                  validator: TValidator.validatePassword,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: confirmPasswordController,
                  decoration: authInputDecoration(
                    hint: TTexts.signupConfirmPasswordLabel,
                    prefix: Icons.lock,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return TValidator.validatePassword(value);
                  },
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
