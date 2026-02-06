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
    
    // Remove spaces, dashes, and plus signs for validation
    final cleanedPhone = value.replaceAll(RegExp(r'[\s\-+]'), '');
    
    // Sri Lankan phone number validation
    // Mobile: 07X-XXXXXXX (10 digits starting with 07)
    // Landline: 0XX-XXXXXXX (9-10 digits starting with 0, not 07)
    
    // Check if it starts with 0
    if (!cleanedPhone.startsWith('0')) {
      return l10n?.pleaseEnterAValidSriLankanPhoneNumber ?? 
          'Enter a valid Sri Lankan phone number. Mobile: 07X-XXXXXXX or Landline: 0XX-XXXXXXX';
    }
    
    // Check if it's all digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanedPhone)) {
      return l10n?.pleaseEnterAValidSriLankanPhoneNumber ?? 
          'Enter a valid Sri Lankan phone number. Mobile: 07X-XXXXXXX or Landline: 0XX-XXXXXXX';
    }
    
    // Mobile number validation: Must start with 07 and be exactly 10 digits
    if (cleanedPhone.startsWith('07')) {
      if (cleanedPhone.length == 10) {
        // Valid mobile number format: 07X-XXXXXXX
        return null;
      } else {
        return l10n?.pleaseEnterAValidSriLankanPhoneNumber ?? 
            'Enter a valid Sri Lankan phone number. Mobile: 07X-XXXXXXX or Landline: 0XX-XXXXXXX';
      }
    }
    
    // Landline validation: Starts with 0 (but not 07), length 9-10 digits
    // Common formats: 011-XXXXXXX (Colombo, 10 digits), 081-XXXXXXX (Kandy, 10 digits), etc.
    if (cleanedPhone.startsWith('0') && cleanedPhone.length >= 9 && cleanedPhone.length <= 10) {
      // Valid landline format
      return null;
    }
    
    // If none of the above match, return error
    return l10n?.pleaseEnterAValidSriLankanPhoneNumber ?? 
        'Enter a valid Sri Lankan phone number. Mobile: 07X-XXXXXXX or Landline: 0XX-XXXXXXX';
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

