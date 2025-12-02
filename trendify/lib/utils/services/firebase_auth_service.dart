import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

/// AppUser built solely from Firebase Auth user properties.
class AppUser {
  final String uid;
  final String? email;
  final String? displayName; // cleaned display name without role marker
  final String? photoURL;
  final String role; // 'customer' | 'seller'
  final bool emailVerified;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.role,
    required this.emailVerified,
  });

  factory AppUser.fromFirebaseUser(fb.User user) {
    final parsed = _parseDisplayName(user.displayName);
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: parsed.displayName,
      photoURL: user.photoURL,
      role: parsed.role,
      emailVerified: user.emailVerified,
    );
  }
}

class _DisplayNameParseResult {
  final String? displayName;
  final String role;
  _DisplayNameParseResult(this.displayName, this.role);
}

_DisplayNameParseResult _parseDisplayName(String? raw) {
  // We store role as a suffix marker: "<name>||role:<role>"
  if (raw == null) return _DisplayNameParseResult(null, 'customer');
  const marker = '||role:';
  final idx = raw.indexOf(marker);
  if (idx == -1) return _DisplayNameParseResult(raw, 'customer');
  final name = raw.substring(0, idx);
  final role = raw.substring(idx + marker.length);
  return _DisplayNameParseResult(name.isEmpty ? null : name, role);
}

String _encodeDisplayName(String? displayName, String role) {
  final namePart = (displayName ?? '').trim();
  return '$namePart||role:$role';
}

class FirebaseAuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuthService();

  /// Emits AppUser changes. Uses distinct to avoid rapid rebuilds when nothing meaningful changed.
  Stream<AppUser?> get appUserChanges => _auth
      .authStateChanges()
      .map((fb.User? u) => u == null ? null : AppUser.fromFirebaseUser(u))
      .distinct((prev, next) {
        // Avoid rebuilds when uid and emailVerified didn't change
        if (identical(prev, next)) return true;
        if (prev == null && next == null) return true;
        if (prev == null || next == null) return false;
        return prev.uid == next.uid &&
            prev.emailVerified == next.emailVerified &&
            prev.role == next.role;
      });

  /// Raw Firebase user stream if needed
  Stream<fb.User?> get firebaseUserChanges => _auth.authStateChanges();

  /// Email/password signup. Stores role inside displayName marker.
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
    String role = 'customer',
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user!;

      // encode role into displayName so we don't need Firestore
      final encoded = _encodeDisplayName(displayName ?? user.displayName, role);
      await user.updateDisplayName(encoded);

      try {
        await user.sendEmailVerification();
      } catch (_) {}

      // reload to ensure local user object is fresh
      await user.reload();

      final reloaded = _auth.currentUser!;
      return AppUser.fromFirebaseUser(reloaded);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  /// Email/password sign in
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user!;
      return AppUser.fromFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  /// Google Sign-In without Firestore. If the signed-in user's displayName lacks a role marker,
  /// we add a default role by updating the displayName.
  Future<AppUser?> signInWithGoogle({String defaultRole = 'customer'}) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      var user = userCred.user!;

      final parsed = _parseDisplayName(user.displayName);
      if (parsed.role.isEmpty ||
          !(user.displayName ?? '').contains('||role:')) {
        // set default role if none encoded
        final encoded = _encodeDisplayName(user.displayName, defaultRole);
        await user.updateDisplayName(encoded);
        await user.reload();
        user = _auth.currentUser!;
      }

      return AppUser.fromFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  /// Sends a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  /// Verifies a password reset code and optionally confirms reset with new password
  Future<String> verifyPasswordResetCode(String code) async {
    try {
      final email = await _auth.verifyPasswordResetCode(code);
      return email;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  /// Sends email verification to current user
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user');
    if (user.emailVerified) return;
    try {
      await user.sendEmailVerification();
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  /// Checks email verification status by reloading the user
  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    try {
      await user.reload();
      final reloaded = _auth.currentUser!;
      return reloaded.emailVerified;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      try {
        await _googleSignIn.signOut();
      } catch (_) {}
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  /// Extract role from current user displayName marker
  String getUserRole() {
    final user = _auth.currentUser;
    if (user == null) return 'customer';
    final parsed = _parseDisplayName(user.displayName);
    return parsed.role;
  }

  Future<AppUser?> getCurrentAppUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser.fromFirebaseUser(user);
  }

  String _mapAuthError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email already in use.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'User account has been disabled.';
      default:
        return e.message ?? 'Authentication error';
    }
  }
}
