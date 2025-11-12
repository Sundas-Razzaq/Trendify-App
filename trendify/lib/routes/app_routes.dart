import 'package:get/get.dart';
import 'package:trendify/features/authentication/screens/signup.dart';
import 'package:trendify/features/authentication/screens/login_screen.dart';
import 'package:trendify/features/authentication/screens/email_verification_screen.dart';
import 'package:trendify/features/authentication/screens/reset_password_screen.dart';
import 'package:trendify/features/authentication/screens/otp_verification_screen.dart';
import 'package:trendify/features/authentication/screens/forgot_password_screen.dart';
import 'package:trendify/features/authentication/screens/logout_screen.dart';
import 'package:trendify/features/shop/screens/main_screen.dart';
import 'package:trendify/features/seller/screens/seller_dashboard.dart';
import 'package:trendify/features/seller/screens/seller_main.dart';
import 'package:trendify/features/seller/screens/seller_add_product.dart';
import 'package:trendify/features/seller/screens/seller_manage_products.dart';
import 'package:trendify/features/seller/screens/seller_orders.dart';
import 'package:trendify/features/seller/screens/seller_inventory.dart';
import 'package:trendify/features/seller/screens/seller_reviews.dart';
import 'package:trendify/features/shop/screens/home/widgets/decide.dart';
import 'package:trendify/features/profile/screens/profile_screen.dart';
// Individual tab screens are shown via `MainScreen` with an initial index.

class AppRoutes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String emailVerification = '/email-verification';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String logout = '/logout';
  static const String home = '/home';
  static const String main = '/main';
  static const String decide = '/decide';
  static const String sellerDashboard = '/seller-dashboard';
  // Seller routes
  static const String sellerMain = '/seller';
  static const String sellerAddProduct = '/seller/add-product';
  static const String sellerManageProducts = '/seller/manage-products';
  static const String sellerOrders = '/seller/orders';
  static const String sellerInventory = '/seller/inventory';
  static const String sellerReviews = '/seller/reviews';
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
    GetPage(name: logout, page: () => const LogoutScreen()),
    // Decide screen shown after signup/login to choose customer or seller
    GetPage(name: decide, page: () => const DecideScreen()),
    // Seller dashboard route
    GetPage(name: sellerDashboard, page: () => const SellerDashboard()),
    // Seller main (panel)
    GetPage(name: sellerMain, page: () => const SellerMain()),
    GetPage(name: sellerAddProduct, page: () => const SellerAddProduct()),
    GetPage(
      name: sellerManageProducts,
      page: () => const SellerManageProducts(),
    ),
    GetPage(name: sellerOrders, page: () => const SellerOrders()),
    GetPage(name: sellerInventory, page: () => const SellerInventory()),
    GetPage(name: sellerReviews, page: () => const SellerReviews()),
    // Navigate to the MainScreen with the appropriate tab selected when
    // these top-level routes are used (e.g., from the drawer).
    GetPage(name: home, page: () => const MainScreen(initialIndex: 0)),
    GetPage(name: main, page: () => const MainScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: wishlist, page: () => const MainScreen(initialIndex: 1)),
    GetPage(name: cart, page: () => const MainScreen(initialIndex: 2)),
    GetPage(name: search, page: () => const MainScreen(initialIndex: 3)),
    GetPage(name: settings, page: () => const MainScreen(initialIndex: 4)),
  ];
}
