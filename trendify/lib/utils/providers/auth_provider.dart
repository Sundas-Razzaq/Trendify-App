import 'package:flutter/material.dart';
import 'package:trendify/utils/services/firebase_auth_service.dart';

/// AuthProvider using ChangeNotifier. Designed to work with Provider package in the UI.
class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  AppUser? _currentUser;
  bool _isLoadingGeneral = false;
  bool _isLoadingEmail = false;
  bool _isLoadingGoogle = false;
  String? _errorMessage;

  AppUser? get currentUser => _currentUser;
  bool get isLoading =>
      _isLoadingGeneral || _isLoadingEmail || _isLoadingGoogle;
  bool get isLoadingEmail => _isLoadingEmail;
  bool get isLoadingGoogle => _isLoadingGoogle;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _init();
  }

  void _init() async {
    // Initialize current user from firebase if present
    try {
      _setLoadingGeneral(true);
      final u = await _authService.getCurrentAppUser();
      _currentUser = u;
    } catch (_) {
      // ignore
    } finally {
      _setLoadingGeneral(false);
    }

    // Listen to auth state changes
    _authService.appUserChanges.listen((u) {
      _currentUser = u;
      notifyListeners();
    });
  }

  void _setLoadingGeneral(bool v) {
    _isLoadingGeneral = v;
    notifyListeners();
  }

  void _setLoadingEmail(bool v) {
    _isLoadingEmail = v;
    notifyListeners();
  }

  void _setLoadingGoogle(bool v) {
    _isLoadingGoogle = v;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  /// Sign up with email/password and role. Returns true on success.
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
    String role = 'customer',
  }) async {
    _setLoadingEmail(true);
    _setError(null);
    try {
      final user = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );
      _currentUser = user;
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoadingEmail(false);
    }
  }

  /// Sign in with email/password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoadingEmail(true);
    _setError(null);
    try {
      final user = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      _currentUser = user;
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoadingEmail(false);
    }
  }

  /// Google Sign-In
  Future<bool> signInWithGoogle({String defaultRole = 'customer'}) async {
    _setLoadingGoogle(true);
    _setError(null);
    try {
      final user = await _authService.signInWithGoogle(
        defaultRole: defaultRole,
      );
      if (user == null) {
        _setError('Google sign-in aborted');
        return false;
      }
      _currentUser = user;
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoadingGoogle(false);
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoadingEmail(true);
    _setError(null);
    try {
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoadingEmail(false);
    }
  }

  /// Verify password reset code (returns email associated)
  Future<String?> verifyPasswordResetCode(String code) async {
    _setLoadingGeneral(true);
    _setError(null);
    try {
      final email = await _authService.verifyPasswordResetCode(code);
      return email;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoadingGeneral(false);
    }
  }

  /// Confirm password reset (using code + new password)
  Future<bool> confirmPasswordReset(String code, String newPassword) async {
    _setLoadingGeneral(true);
    _setError(null);
    try {
      await _authService.confirmPasswordReset(code, newPassword);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoadingGeneral(false);
    }
  }

  /// Send email verification to current user
  Future<bool> sendEmailVerification() async {
    _setLoadingGeneral(true);
    _setError(null);
    try {
      await _authService.sendEmailVerification();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoadingGeneral(false);
    }
  }

  /// Check email verified status
  Future<bool> isEmailVerified() async {
    _setLoadingGeneral(true);
    _setError(null);
    try {
      final v = await _authService.isEmailVerified();
      // refresh current user if necessary
      _currentUser = await _authService.getCurrentAppUser();
      return v;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoadingGeneral(false);
    }
  }

  /// Sign out - optional navigate to route
  Future<bool> signOut() async {
    _setLoadingGeneral(true);
    _setError(null);
    try {
      await _authService.signOut();
      _currentUser = null;
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoadingGeneral(false);
    }
  }
}
