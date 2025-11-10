import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/utils/validators/validation.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: TSizes.spaceBtwItems),
              Text(
                TTexts.signupTitle,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: TColors.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              Text(
                TTexts.signupSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TSizes.spaceBtwSections),
              // Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: TTexts.signupNameLabel,
                  prefixIcon: Icon(Icons.person, color: TColors.primary),
                ),
                keyboardType: TextInputType.name,
                validator: TValidator.valiNamedate,
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              // Email Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: TTexts.signupEmailLabel,
                  prefixIcon: Icon(Icons.email, color: TColors.primary),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: TValidator.validateEmail,
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              // Password Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: TTexts.signupPasswordLabel,
                  prefixIcon: Icon(Icons.lock, color: TColors.primary),
                ),
                obscureText: true,
                validator: TValidator.validatePassword,
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              // Confirm Password Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: TTexts.signupConfirmPasswordLabel,
                  prefixIcon: Icon(Icons.lock, color: TColors.primary),
                ),
                obscureText: true,
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: TSizes.spaceBtwSections),
              // Signup Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  child: Text(TTexts.signupButton),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),
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
                      style: TextStyle(color: TColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
