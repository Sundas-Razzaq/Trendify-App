import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/colors.dart';
// import 'package:trendify/utils/constants/sizes.dart';

InputDecoration authInputDecoration({required String hint, IconData? prefix}) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    prefixIcon: prefix != null
        ? Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(prefix, color: TColors.primary),
          )
        : null,
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: TColors.primary),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );
}

TextStyle authHeadingStyle(BuildContext context) {
  return Theme.of(context).textTheme.headlineSmall!.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );
}

ButtonStyle authButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: TColors.primary,
    padding: const EdgeInsets.symmetric(vertical: 18),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );
}
