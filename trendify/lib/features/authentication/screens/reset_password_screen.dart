import 'package:flutter/material.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/constants/texts_strings.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text(TTexts.resetPasswordTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: TTexts.signupPasswordLabel,
                ),
                obscureText: true,
                validator: TValidator.validatePassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: TTexts.signupConfirmPasswordLabel,
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
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Only UI navigation: After password reset, go to login page
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
    );
  }
}
