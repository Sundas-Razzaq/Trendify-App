import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/routes/app_routes.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/features/authentication/widgets/auth_styles.dart';
import 'package:trendify/features/authentication/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
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
                Text('Welcome Back!', style: authHeadingStyle(context)),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Email
                TextFormField(
                  controller: controller.emailController,
                  decoration: authInputDecoration(
                    hint: TTexts.loginEmailLabel,
                    prefix: Icons.person,
                  ),
                  validator: TValidator.validateEmail,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: controller.passwordController,
                  decoration: authInputDecoration(
                    hint: TTexts.loginPasswordLabel,
                    prefix: Icons.lock,
                  ),
                  obscureText: true,
                  validator: TValidator.validatePassword,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: authButtonStyle(),
                    onPressed: () async {
                      await controller.login();
                    },
                    child: Obx(
                      () => controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(TTexts.loginButton),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/forgot-password'),
                  child: Text(
                    TTexts.loginForgotPassword,
                    style: TextStyle(color: TColors.primary),
                  ),
                ),

                const SizedBox(height: TSizes.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const Text('- OR Continue with -')],
                ),
                const SizedBox(height: TSizes.sm),
                // social icons could be added here
                const SizedBox(height: TSizes.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.signup,
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: TColors.primary),
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
