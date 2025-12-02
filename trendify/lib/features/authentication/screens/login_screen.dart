import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/routes/app_routes.dart';
import 'package:trendify/utils/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    final auth = context.read<AuthProvider>();
    if (!_formKey.currentState!.validate()) return;

    final success = await auth.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.decide);
      return;
    }

    if (!success) {
      final err = auth.errorMessage;
      if (err != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: TColors.error),
        );
      }
    }
  }

  Future<void> _onGoogleSignIn() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithGoogle(defaultRole: 'customer');

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.decide);
      return;
    }

    if (!success) {
      final err = auth.errorMessage;
      if (err != null && mounted) {
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

                  // Logo/Header Section
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
                          Icons.account_circle_rounded,
                          size: 50,
                          color: TColors.primary,
                        ),
                      ),
                      SizedBox(height: TSizes.lg),
                      Text(
                        TTexts.loginTitle,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: TColors.textprimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: TSizes.sm),
                      Text(
                        'Welcome back! Please enter your details',
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
                              labelText: TTexts.loginEmailLabel,
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
                          SizedBox(height: TSizes.lg),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: TTexts.loginPasswordLabel,
                              labelStyle: TextStyle(color: TColors.darkGrey),
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: TColors.primary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: TColors.darkGrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
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
                            validator: TValidator.validatePassword,
                            onChanged: (_) => auth.clearError(),
                          ),

                          SizedBox(height: TSizes.md),

                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/forgot-password',
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                TTexts.loginForgotPassword,
                                style: TextStyle(
                                  color: TColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: TSizes.fontSizeSm,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: TSizes.lg),

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

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: auth.isLoading
                                  ? null
                                  : _onLoginPressed,
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
                                      TTexts.loginButton,
                                      style: TextStyle(
                                        fontSize: TSizes.fontSizeLg,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: TSizes.lg),

                          // Divider with "OR"
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: TColors.grey, height: 1),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: TSizes.md,
                                ),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: TColors.darkGrey,
                                    fontSize: TSizes.fontSizeSm,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: TColors.grey, height: 1),
                              ),
                            ],
                          ),

                          SizedBox(height: TSizes.lg),

                          // Google Sign-In Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: auth.isLoading
                                  ? null
                                  : _onGoogleSignIn,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: TColors.textprimary,
                                side: BorderSide(color: TColors.grey),
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
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/google_logo.png', // Add Google logo asset
                                          height: 24,
                                          width: 24,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.g_mobiledata_rounded,
                                                  size: 24,
                                                  color: TColors.textprimary,
                                                );
                                              },
                                        ),
                                        SizedBox(width: TSizes.md),
                                        Text(
                                          'Sign in with Google',
                                          style: TextStyle(
                                            fontSize: TSizes.fontSizeLg,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          SizedBox(height: TSizes.xl),

                          // Don't have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TTexts.loginNoAccount,
                                style: TextStyle(
                                  color: TColors.darkGrey,
                                  fontSize: TSizes.fontSizeSm,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.signup,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: TSizes.xs,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  TTexts.loginSignupLink,
                                  style: TextStyle(
                                    color: TColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: TSizes.fontSizeSm,
                                  ),
                                ),
                              ),
                            ],
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
