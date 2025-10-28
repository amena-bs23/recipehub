import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'validation.dart';

class PasswordValidation extends Validation<String> {
  PasswordValidation({
    this.minLength = 6,
    this.number = false,
    this.lowerCase = false,
    this.upperCase = false,
    this.specialChar = false,
  });

  final int minLength;
  final bool number;
  final bool lowerCase;
  final bool upperCase;
  final bool specialChar;

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null) return null;

    if (value.length < minLength) {
      final localizedNumber = NumberFormat.decimalPattern(
        Localizations.localeOf(context).languageCode,
      ).format(minLength);

      return 'Password min length validation failed';
    }

    if (number && !value.contains(RegExp(r'\d'))) {
      return 'Password number validation failed';
    }

    if (lowerCase && !value.contains(RegExp(r'[a-z]'))) {
      return 'Password lowercase validation failed';
    }

    if (upperCase && !value.contains(RegExp(r'[A-Z]'))) {
      return 'Password uppercase validation failed';
    }

    if (specialChar && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password special character validation failed';
    }

    return null;
  }
}
