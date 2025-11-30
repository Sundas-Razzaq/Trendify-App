// Lightweight placeholder AuthService implementation.
// If you already have a concrete implementation, replace this file's
// contents with your real service. These stubs are intentionally simple
// and safe so the app can compile during development.

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  /// Simulate login: returns `null` on success or an error message.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  /// Simulate Google sign-in: returns a non-null result on success,
  /// or `null` when the user cancels the flow. Replace with real
  /// implementation when integrating Firebase/Google sign-in.
  Future<dynamic?> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  /// Simulate logout.
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Current user placeholder
  dynamic get currentUser => null;
}
