import 'package:get/get.dart';
import 'package:trendify/features/authentication/screens/signup.dart';
import 'package:trendify/features/authentication/screens/login_screen.dart';
import 'package:trendify/features/authentication/screens/email_verification_screen.dart';
import 'package:trendify/features/authentication/screens/reset_password_screen.dart';
import 'package:trendify/features/authentication/screens/otp_verification_screen.dart';
import 'package:trendify/features/authentication/screens/forgot_password_screen.dart';
import 'package:trendify/features/shop/screens/home/home_screen.dart';
import 'package:trendify/features/shop/screens/main_screen.dart';
import 'package:trendify/features/profile/screens/profile_screen.dart';
import 'package:trendify/features/shop/screens/wishlist/wishlist_screen.dart';
import 'package:trendify/features/shop/screens/cart/cart_screen.dart';
import 'package:trendify/features/shop/screens/search/search_screen.dart';
import 'package:trendify/features/shop/screens/settings/settings_screen.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String emailVerification = '/email-verification';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String main = '/main';
  static const String profile = '/profile';

  static const String wishlist = '/wishlist';
  static const String cart = '/cart';
  static const String search = '/search';
  static const String settings = '/settings';

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
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: main, page: () => const MainScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: wishlist, page: () => const WishlistScreen()),
    GetPage(name: cart, page: () => const CartScreen()),
    GetPage(name: search, page: () => const SearchScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
  ];
}
