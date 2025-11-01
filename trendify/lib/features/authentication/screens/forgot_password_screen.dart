import 'package:flutter/material.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/constants/texts_strings.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text(TTexts.resetPasswordTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: TTexts.resetPasswordEmailLabel,
                ),
                validator: TValidator.validateEmail,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
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
    );
  }
}
