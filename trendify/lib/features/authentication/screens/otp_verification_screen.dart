import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendify/utils/constants/colors.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/texts_strings.dart';
import 'package:trendify/utils/validators/validation.dart';
import 'package:trendify/utils/providers/auth_provider.dart';
import 'package:trendify/features/authentication/screens/success_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _otpController;
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _digitControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();

    // Setup focus node listeners
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && i < _focusNodes.length - 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _digitControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateOTP() {
    String otp = '';
    for (var controller in _digitControllers) {
      otp += controller.text;
    }
    _otpController.text = otp;
  }

  Future<void> _onVerify() async {
    final auth = context.read<AuthProvider>();

    // Build OTP from individual digits
    String otp = '';
    for (var controller in _digitControllers) {
      otp += controller.text;
    }
    _otpController.text = otp;

    if (!_formKey.currentState!.validate()) return;

    final email = await auth.verifyPasswordResetCode(
      _otpController.text.trim(),
    );

    if (email != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SuccessScreen(message: 'Code verified.'),
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
                          Icons.sms_rounded,
                          size: 50,
                          color: TColors.primary,
                        ),
                      ),
                      SizedBox(height: TSizes.lg),
                      Text(
                        'Verify OTP',
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
                          // OTP Input Grid
                          Text(
                            'Enter 6-digit code',
                            style: TextStyle(
                              color: TColors.textprimary,
                              fontSize: TSizes.fontSizeMd,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: TSizes.lg),

                          // OTP Digits
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 50,
                                height: 60,
                                child: TextFormField(
                                  controller: _digitControllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: TColors.textprimary,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor: TColors.lightGrey,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        TSizes.borderRadiusMd,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        TSizes.borderRadiusMd,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        TSizes.borderRadiusMd,
                                      ),
                                      borderSide: BorderSide(
                                        color: TColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.length == 1 && index < 5) {
                                      _focusNodes[index + 1].requestFocus();
                                    }
                                    _updateOTP();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  },
                                ),
                              );
                            }),
                          ),

                          SizedBox(height: TSizes.lg),

                          // Hidden OTP Field for validation
                          Visibility(
                            visible: false,
                            child: TextFormField(
                              controller: _otpController,
                              validator: TValidator.validateOTP,
                              onChanged: (_) => auth.clearError(),
                            ),
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

                          // Verify Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: auth.isLoading ? null : _onVerify,
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
                                      TTexts.emailVerificationContinue,
                                      style: TextStyle(
                                        fontSize: TSizes.fontSizeLg,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: TSizes.md),

                          // Resend Code Link
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Resend functionality not implemented yet',
                                  ),
                                  backgroundColor: TColors.warning,
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: TSizes.md,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Resend Code',
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
