import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/utils/providers/auth_provider.dart';
import 'package:trendify/routes/app_routes.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    // poll verification status every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      final verified = await auth.isEmailVerified();
      if (verified && mounted) {
        _timer?.cancel();
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    final auth = context.read<AuthProvider>();
    await auth.sendEmailVerification();
    final err = auth.errorMessage;
    if (err != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: TColors.error),
      );
    }
    if (mounted && auth.isLoading == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification email resent'),
          backgroundColor: TColors.success,
        ),
      );
    }
  }

  Future<void> _checkVerification() async {
    setState(() => _isChecking = true);
    final auth = context.read<AuthProvider>();
    final ok = await auth.isEmailVerified();

    if (ok && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email not verified yet'),
          backgroundColor: TColors.warning,
        ),
      );
    }
    if (mounted) setState(() => _isChecking = false);
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
                        width: 100,
                        height: 100,
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
                          Icons.mark_email_read_rounded,
                          size: 50,
                          color: TColors.primary,
                        ),
                      ),
                      SizedBox(height: TSizes.lg),
                      Text(
                        TTexts.emailVerificationTitle,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: TColors.textprimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: TSizes.sm),
                      Text(
                        TTexts.emailVerificationSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: TColors.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: TSizes.lg),

                      // Animated Progress Indicator
                      Container(
                        padding: EdgeInsets.all(TSizes.md),
                        decoration: BoxDecoration(
                          color: TColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            TSizes.borderRadiusLg,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: TColors.primary,
                              ),
                            ),
                            SizedBox(width: TSizes.md),
                            Text(
                              'Checking verification status...',
                              style: TextStyle(
                                color: TColors.textprimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: TSizes.xl * 2),

                  // Action Card
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
                    child: Column(
                      children: [
                        // Instructions
                        Container(
                          padding: EdgeInsets.all(TSizes.lg),
                          decoration: BoxDecoration(
                            color: TColors.lightGrey,
                            borderRadius: BorderRadius.circular(
                              TSizes.borderRadiusLg,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: TColors.success,
                                    size: 20,
                                  ),
                                  SizedBox(width: TSizes.sm),
                                  Expanded(
                                    child: Text(
                                      'Check your email inbox',
                                      style: TextStyle(
                                        color: TColors.textprimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: TSizes.sm),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: TColors.success,
                                    size: 20,
                                  ),
                                  SizedBox(width: TSizes.sm),
                                  Expanded(
                                    child: Text(
                                      'Click the verification link',
                                      style: TextStyle(
                                        color: TColors.textprimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: TSizes.sm),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: TColors.success,
                                    size: 20,
                                  ),
                                  SizedBox(width: TSizes.sm),
                                  Expanded(
                                    child: Text(
                                      'Return to this screen',
                                      style: TextStyle(
                                        color: TColors.textprimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: TSizes.xl),

                        // Resend Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: auth.isLoading ? null : _resend,
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
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_rounded, size: 20),
                                      SizedBox(width: TSizes.sm),
                                      Text(
                                        TTexts.emailVerificationResend,
                                        style: TextStyle(
                                          fontSize: TSizes.fontSizeLg,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        SizedBox(height: TSizes.lg),

                        // Check Now Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: _isChecking ? null : _checkVerification,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: TColors.textprimary,
                              side: BorderSide(color: TColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  TSizes.buttonRadius,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: TSizes.md,
                              ),
                            ),
                            child: _isChecking
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh_rounded, size: 20),
                                      SizedBox(width: TSizes.sm),
                                      Text(
                                        TTexts.emailVerificationContinue,
                                        style: TextStyle(
                                          fontSize: TSizes.fontSizeLg,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
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
