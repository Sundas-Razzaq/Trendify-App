class TValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    // Allow letters (including common accented letters), spaces, periods,
    // hyphens and apostrophes which are common in personal names.
    final nameRegex = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ .'\-]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, apostrophes, hyphens and dots';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? original) {
    if (value == null || value.isEmpty) {
      return 'Confirm password cannot be empty';
    }
    if (original == null || original.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateOTP(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return 'Code cannot be empty';
    }
    if (value.length != length) {
      return 'Code must be $length digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Code must be numeric';
    }
    return null;
  }

  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    //check for uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    //check for lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    //check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    //check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Invalid phone number format';
    }
    return null;
  }
}
