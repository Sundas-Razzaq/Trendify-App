import 'package:flutter/material.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/constants/texts_strings.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final otpController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text(TTexts.emailVerificationTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: otpController,
                decoration: const InputDecoration(
                  labelText: TTexts.emailVerificationSubtitle,
                ),
                validator: TValidator.validateOTP,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
    );
  }
}
