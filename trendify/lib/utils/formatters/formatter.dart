import 'package:intl/intl.dart';

class TFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '+${phoneNumber.substring(0, 4)} (${phoneNumber.substring(4, 7)}) ${phoneNumber.substring(7)}';
    } else {
      return phoneNumber; // Return as is if format is unrecognized
    }
  }

  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check if the number already starts with the country code
    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2); // Assuming country code is '1' for US

    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;
      if (i == 0 && countryCode == '+1') {
        groupLength = 3; // Area code
      }

      int end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write('-');
      }

      i = end;
    }

    return formattedNumber.toString();
  }
}
