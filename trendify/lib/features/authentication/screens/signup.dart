import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/routes/app_routes.dart';
import 'package:trendify/utils/providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  String _role = 'customer';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onSignup() async {
    final auth = context.read<AuthProvider>();
    if (!_formKey.currentState!.validate()) return;

    final success = await auth.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
      role: _role,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
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
                  SizedBox(height: TSizes.xl),

                  // Logo/Header Section
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
                          Icons.person_add_alt_1_rounded,
                          size: 40,
                          color: TColors.primary,
                        ),
                      ),
                      SizedBox(height: TSizes.lg),
                      Text(
                        TTexts.signupTitle,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: TColors.textprimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: TSizes.sm),
                      Text(
                        TTexts.signupSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: TColors.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: TSizes.xl),

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
                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: TTexts.signupNameLabel,
                              labelStyle: TextStyle(color: TColors.darkGrey),
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
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
                            keyboardType: TextInputType.name,
                            validator: TValidator.validateName,
                            onChanged: (_) => auth.clearError(),
                          ),
                          SizedBox(height: TSizes.lg),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: TTexts.signupEmailLabel,
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
                              labelText: TTexts.signupPasswordLabel,
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
                          SizedBox(height: TSizes.lg),

                          // Confirm Password Field
                          TextFormField(
                            controller: _confirmController,
                            obscureText: _obscureConfirm,
                            decoration: InputDecoration(
                              labelText: TTexts.signupConfirmPasswordLabel,
                              labelStyle: TextStyle(color: TColors.darkGrey),
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: TColors.primary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: TColors.darkGrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirm = !_obscureConfirm;
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
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return TValidator.validatePassword(value);
                            },
                            onChanged: (_) => auth.clearError(),
                          ),
                          SizedBox(height: TSizes.lg),

                          // Role Selection - Beautiful Segmented Button
                          Container(
                            decoration: BoxDecoration(
                              color: TColors.lightGrey,
                              borderRadius: BorderRadius.circular(
                                TSizes.inputFieldRadius,
                              ),
                            ),
                            padding: EdgeInsets.all(TSizes.xs),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ChoiceChip(
                                    label: Text(
                                      'Customer',
                                      style: TextStyle(
                                        color: _role == 'customer'
                                            ? TColors.white
                                            : TColors.darkGrey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    selected: _role == 'customer',
                                    onSelected: (selected) {
                                      setState(() {
                                        _role = 'customer';
                                      });
                                    },
                                    selectedColor: TColors.primary,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        TSizes.borderRadiusMd,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: TSizes.md,
                                      horizontal: TSizes.sm,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ChoiceChip(
                                    label: Text(
                                      'Seller',
                                      style: TextStyle(
                                        color: _role == 'seller'
                                            ? TColors.white
                                            : TColors.darkGrey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    selected: _role == 'seller',
                                    onSelected: (selected) {
                                      setState(() {
                                        _role = 'seller';
                                      });
                                    },
                                    selectedColor: TColors.primary,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        TSizes.borderRadiusMd,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: TSizes.md,
                                      horizontal: TSizes.sm,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: TSizes.xl),

                          // Signup Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: auth.isLoading ? null : _onSignup,
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
                                      TTexts.signupButton,
                                      style: TextStyle(
                                        fontSize: TSizes.fontSizeLg,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: TSizes.lg),

                          // Already have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TTexts.signupAlreadyHaveAccount,
                                style: TextStyle(
                                  color: TColors.darkGrey,
                                  fontSize: TSizes.fontSizeSm,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.login,
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
                                  TTexts.signupLoginLink,
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
