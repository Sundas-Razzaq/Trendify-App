import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/features/authentication/widgets/auth_styles.dart';
import 'package:get/get.dart';
import 'package:trendify/features/authentication/controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    return Scaffold(
      backgroundColor: TColors.light,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: TSizes.spaceBtwSections),
                Text('Create an account', style: authHeadingStyle(context)),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'Sign up to get started',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Name Field
                TextFormField(
                  controller: controller.nameController,
                  decoration: authInputDecoration(
                    hint: TTexts.signupNameLabel,
                    prefix: Icons.person,
                  ),
                  keyboardType: TextInputType.name,
                  validator: TValidator.valiNamedate,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Email Field
                TextFormField(
                  controller: controller.emailController,
                  decoration: authInputDecoration(
                    hint: TTexts.signupEmailLabel,
                    prefix: Icons.email,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: TValidator.validateEmail,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Password Field
                TextFormField(
                  controller: controller.passwordController,
                  decoration: authInputDecoration(
                    hint: TTexts.signupPasswordLabel,
                    prefix: Icons.lock,
                  ),
                  obscureText: true,
                  validator: TValidator.validatePassword,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Confirm Password Field
                TextFormField(
                  controller: controller.confirmPasswordController,
                  decoration: authInputDecoration(
                    hint: TTexts.signupConfirmPasswordLabel,
                    prefix: Icons.lock,
                  ),
                  obscureText: true,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: authButtonStyle(),
                    onPressed: () async {
                      await controller.register();
                    },
                    child: Obx(
                      () => controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                          : Text(TTexts.signupButton),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Link to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TTexts.signupAlreadyHaveAccount),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        TTexts.signupLoginLink,
                        style: const TextStyle(color: Color(0xFFE94B4B)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
