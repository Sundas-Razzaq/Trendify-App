import 'package:get/get.dart';
import 'package:trendify/features/authentication/screens/signup.dart';
import 'package:trendify/features/authentication/screens/login_screen.dart';
import 'package:trendify/features/authentication/screens/email_verification_screen.dart';
import 'package:trendify/features/authentication/screens/reset_password_screen.dart';
import 'package:trendify/features/authentication/screens/otp_verification_screen.dart';
import 'package:trendify/features/authentication/screens/forgot_password_screen.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String emailVerification = '/email-verification';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';

  static final routes = [
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(
      name: emailVerification,
      page: () => const EmailVerificationScreen(),
    ),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(name: otpVerification, page: () => const OTPVerificationScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
  ];
}
