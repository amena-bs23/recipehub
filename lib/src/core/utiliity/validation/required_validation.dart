import 'package:flutter/material.dart';

import 'validation.dart';

class RequiredValidation<T> extends Validation<T> {
  @override
  String? validate(BuildContext context, T? value) {
    if (value == null) {
      return 'This field is required';
    }

    if (value is String && (value as String).isEmpty) {
      return 'This field is required';
    }

    return null;
  }
}
