import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendify/utils/services/auth_service.dart';
import 'package:trendify/routes/app_routes.dart';

/// Controller responsible for authentication flows (register, login, logout).
/// Uses `AuthService` for backend operations and exposes form controllers
/// and loading state to the UI via GetX observables.
class AuthController extends GetxController {
  // Text controllers used by auth forms
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Loading state observable
  final isLoading = false.obs;

  /// Registers a new user using `AuthService.signUp`.
  /// Validates the form, ensures passwords match, shows snackbars for
  /// errors/success and navigates to the decide screen on success.
  Future<void> register() async {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) return;

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final String? errorMsg = await AuthService().signUp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (errorMsg != null) {
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
        return;
      }

      Get.snackbar(
        'Success',
        'Account created — please verify your email',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Navigate to decide screen (customer vs seller)
      Get.offAllNamed(AppRoutes.decide);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Signs in the user using Google authentication.
  /// Sets loading state while the process runs. If the user cancels the
  /// Google sign-in flow `AuthService.signInWithGoogle()` should return
  /// `null` and this method will exit silently. On FirebaseAuthException
  /// the error message is shown via snackbar. On success navigates to
  /// the decide screen.
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final result = await AuthService().signInWithGoogle();

      // If the service returns null the user likely cancelled the flow.
      if (result == null) {
        isLoading.value = false;
        return;
      }

      // Successful sign in — navigate to decide screen.
      Get.offAllNamed(AppRoutes.decide);
    } catch (e) {
      // Catch any error from the service (includes user-cancel and other failures)
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Logs in an existing user using `AuthService.login`.
  /// Validates the form, calls the service and navigates to the decide
  /// screen on success; shows error snackbar on failure.
  Future<void> login() async {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) return;

    isLoading.value = true;
    try {
      final String? error = await AuthService().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (error != null) {
        Get.snackbar('Error', error, snackPosition: SnackPosition.BOTTOM);
        return;
      }

      Get.offAllNamed(AppRoutes.decide);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Logs out the current user and navigates to the login screen.
  Future<void> logout() async {
    try {
      await AuthService().logout();
    } catch (e) {
      // ignore errors during logout but show a message
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  /// Returns the current authenticated user from AuthService, if any.
  /// Type is left dynamic to avoid a hard dependency on firebase types here.
  dynamic get currentUser => AuthService().currentUser;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
