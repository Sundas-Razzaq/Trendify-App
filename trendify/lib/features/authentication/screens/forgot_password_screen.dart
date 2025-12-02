import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/providers/auth_provider.dart';
import 'package:trendify/features/authentication/screens/success_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    final auth = context.read<AuthProvider>();
    if (!_formKey.currentState!.validate()) return;

    final success = await auth.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SuccessScreen(
            message: 'A reset link has been sent to your email.',
          ),
        ),
      );
    } else if (mounted) {
      final err = auth.errorMessage;
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: TColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: TColors.linearGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 600 ? screenWidth * 0.2 : TSizes.lg,
              ),
              child: Column(
                children: [
                  SizedBox(height: TSizes.xl * 2),

                  // Back Button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: TColors.textprimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  SizedBox(height: TSizes.lg),

                  // Header Section
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: TColors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: TColors.primary.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock_reset_rounded,
                          size: 40,
                          color: TColors.primary,
                        ),
                      ),
                      SizedBox(height: TSizes.lg),
                      Text(
                        TTexts.resetPasswordTitle,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: TColors.textprimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: TSizes.sm),
                      Text(
                        'Enter your email address and we\'ll send you a reset link',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: TColors.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: TSizes.xl * 2),

                  // Form Card
                  Container(
                    decoration: BoxDecoration(
                      color: TColors.white,
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: TColors.black.withOpacity(0.1),
                          blurRadius: 25,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(TSizes.lg),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: TTexts.resetPasswordEmailLabel,
                              labelStyle: TextStyle(color: TColors.darkGrey),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: TColors.primary,
                              ),
                              filled: true,
                              fillColor: TColors.lightGrey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  TSizes.inputFieldRadius,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: TSizes.md,
                                horizontal: TSizes.md,
                              ),
                            ),
                            style: TextStyle(color: TColors.textprimary),
                            keyboardType: TextInputType.emailAddress,
                            validator: TValidator.validateEmail,
                            onChanged: (_) => auth.clearError(),
                          ),

                          SizedBox(height: TSizes.xl),

                          // Error Message
                          if (auth.errorMessage != null)
                            Container(
                              padding: EdgeInsets.all(TSizes.md),
                              decoration: BoxDecoration(
                                color: TColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  TSizes.borderRadiusMd,
                                ),
                                border: Border.all(
                                  color: TColors.error.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: TColors.error,
                                    size: 20,
                                  ),
                                  SizedBox(width: TSizes.sm),
                                  Expanded(
                                    child: Text(
                                      auth.errorMessage!,
                                      style: TextStyle(
                                        color: TColors.error,
                                        fontSize: TSizes.fontSizeSm,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (auth.errorMessage != null)
                            SizedBox(height: TSizes.lg),

                          // Send Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: auth.isLoading ? null : _onSend,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.primary,
                                foregroundColor: TColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    TSizes.buttonRadius,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: TSizes.md,
                                ),
                              ),
                              child: auth.isLoading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: TColors.white,
                                      ),
                                    )
                                  : Text(
                                      TTexts.resetPasswordButton,
                                      style: TextStyle(
                                        fontSize: TSizes.fontSizeLg,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: TSizes.md),

                          // Back to Login
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: TSizes.md,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Back to Login',
                              style: TextStyle(
                                color: TColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: TSizes.fontSizeSm,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: TSizes.xl * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
