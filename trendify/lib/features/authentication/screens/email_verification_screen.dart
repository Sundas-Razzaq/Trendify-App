import 'package:flutter/material.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/constants/texts_strings.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final otpController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text(TTexts.emailVerificationTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: otpController,
                decoration: const InputDecoration(labelText: 'OTP'),
                validator: TValidator.validateOTP,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
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
