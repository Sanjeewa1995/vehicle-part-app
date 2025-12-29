import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class Validators {
  static String? validateEmail(String? value, BuildContext? context) {
    final l10n = context != null ? AppLocalizations.of(context) : null;
    if (value == null || value.isEmpty) {
      return l10n?.emailIsRequired ?? 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return l10n?.pleaseEnterAValidEmailAddress ?? 'Please enter a valid email address';
    }
    return null;
  }
  
  static String? validatePassword(String? value, BuildContext? context) {
    final l10n = context != null ? AppLocalizations.of(context) : null;
    if (value == null || value.isEmpty) {
      return l10n?.passwordRequired ?? 'Password is required';
    }
    if (value.length < 6) {
      return l10n?.passwordMinLength ?? 'Password must be at least 6 characters';
    }
    return null;
  }
  
  static String? validateRequired(String? value, {String? fieldName, BuildContext? context}) {
    final l10n = context != null ? AppLocalizations.of(context) : null;
    if (value == null || value.isEmpty) {
      if (fieldName != null && l10n != null) {
        return l10n.fieldIsRequired(fieldName);
      }
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }
  
  static String? validatePhoneNumber(String? value, BuildContext? context) {
    final l10n = context != null ? AppLocalizations.of(context) : null;
    if (value == null || value.isEmpty) {
      return l10n?.phoneNumberIsRequired ?? 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return l10n?.pleaseEnterAValidPhoneNumber ?? 'Please enter a valid phone number';
    }
    return null;
  }

  /// Returns a validator function bound to the given context for email validation
  static String? Function(String?) emailValidator(BuildContext context) {
    return (String? value) => validateEmail(value, context);
  }

  /// Returns a validator function bound to the given context for phone number validation
  static String? Function(String?) phoneNumberValidator(BuildContext context) {
    return (String? value) => validatePhoneNumber(value, context);
  }

  /// Returns a validator function bound to the given context for password validation
  static String? Function(String?) passwordValidator(BuildContext context) {
    return (String? value) => validatePassword(value, context);
  }

  /// Returns a validator function bound to the given context for required field validation
  static String? Function(String?) requiredValidator(BuildContext context, {String? fieldName}) {
    return (String? value) => validateRequired(value, fieldName: fieldName, context: context);
  }
}

