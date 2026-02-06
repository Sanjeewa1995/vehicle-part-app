import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Utility class to convert technical error messages to user-friendly messages
class ErrorMessageHelper {
  /// Converts technical error messages to user-friendly messages
  /// [context] is optional - if provided, will use localized error messages
  static String getUserFriendlyMessage(dynamic error, {BuildContext? context}) {
    final l10n = context != null ? AppLocalizations.of(context) : null;
    if (error == null) {
      return l10n?.anUnexpectedErrorOccurred ?? 'An unexpected error occurred. Please try again.';
    }

    String errorString = error.toString();

    // Remove common exception prefixes
    errorString = errorString
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '')
        .trim();

    // Early return: If the message is already user-friendly and doesn't contain HTTP status codes,
    // return it as-is without any conversion (but allow field-specific errors to be processed)
    if (!errorString.contains('HTTP ') && 
        !errorString.contains(':') && // Field-specific errors need processing
        !isTechnicalError(errorString) &&
        errorString.length > 0 &&
        errorString.length < 200) { // Reasonable length for user messages
      // Check if it's a specific error message (not generic)
      final lowerError = errorString.toLowerCase();
      if (!lowerError.contains('invalid input') &&
          !lowerError.contains('validation error') &&
          !lowerError.contains('invalid data') &&
          !lowerError.contains('an error occurred') &&
          !lowerError.contains('something went wrong')) {
        return errorString;
      }
    }

    // Handle HTTP status codes and technical error formats
    if (errorString.contains('HTTP ')) {
      return _parseHttpError(errorString, l10n);
    }

    // Handle non_field_errors format
    if (errorString.contains('non_field_errors')) {
      return _parseNonFieldErrors(errorString, l10n);
    }

    // Handle common error patterns
    if (errorString.toLowerCase().contains('invalid credentials') ||
        errorString.toLowerCase().contains('authentication failed') ||
        errorString.toLowerCase().contains('unauthorized')) {
      return l10n?.invalidPhoneNumberOrPassword ?? 'Invalid phone number or password. Please check your credentials and try again.';
    }

    if (errorString.toLowerCase().contains('connection timeout') ||
        errorString.toLowerCase().contains('timeout')) {
      return l10n?.connectionTimeout ?? 'Connection timeout. Please check your internet connection and try again.';
    }

    if (errorString.toLowerCase().contains('network error') ||
        errorString.toLowerCase().contains('no internet') ||
        errorString.toLowerCase().contains('connection failed')) {
      return l10n?.networkError ?? 'Network error. Please check your internet connection and try again.';
    }

    if (errorString.toLowerCase().contains('server error') ||
        errorString.toLowerCase().contains('500')) {
      return l10n?.serverError ?? 'Server error. Please try again later.';
    }

    if (errorString.toLowerCase().contains('not found') ||
        errorString.toLowerCase().contains('404')) {
      return l10n?.theRequestedResourceWasNotFound ?? 'The requested resource was not found.';
    }

    if (errorString.toLowerCase().contains('bad request') ||
        errorString.toLowerCase().contains('400')) {
      return _parseBadRequestError(errorString, l10n);
    }

    if (errorString.toLowerCase().contains('forbidden') ||
        errorString.toLowerCase().contains('403')) {
      return l10n?.youDoNotHavePermissionToPerformThisAction ?? 'You do not have permission to perform this action.';
    }

    // Handle field-specific errors (like "new_password: Password must contain at least one letter")
    if (errorString.contains(':')) {
      final parsedFieldError = _parseFieldErrors(errorString);
      // If the parsed error is user-friendly (not technical), return it directly
      if (!isTechnicalError(parsedFieldError) && 
          !parsedFieldError.toLowerCase().contains('invalid input') &&
          parsedFieldError.length < 200) {
        return parsedFieldError;
      }
      return parsedFieldError;
    }

    // Try to translate common English error messages first (even if they're user-friendly)
    // This handles cases where errors were already converted to English without context
    final translated = _translateCommonErrorMessage(errorString, l10n);
    if (translated != null) {
      return translated;
    }

    // If it's already a user-friendly message (doesn't contain technical terms), return as is
    if (!isTechnicalError(errorString)) {
      return errorString;
    }

    // Default fallback
    return l10n?.somethingWentWrong ?? 'Something went wrong. Please try again.';
  }

  /// Parses HTTP error messages
  static String _parseHttpError(String errorString, AppLocalizations? l10n) {
    // Extract status code
    final statusCodeMatch = RegExp(r'HTTP (\d+)').firstMatch(errorString);
    final statusCode = statusCodeMatch?.group(1);

    // Extract the actual error message (after HTTP XXX:)
    String message = errorString.replaceAll(RegExp(r'HTTP \d+:\s*'), '');

    // Remove technical details
    message = message.replaceAll(RegExp(r'\([^)]*\)'), '').trim();
    message = message.replaceAll(RegExp(r'\[[^\]]*\]'), '').trim();

    // Handle specific status codes
    switch (statusCode) {
      case '400':
        return _parseBadRequestError(message, l10n);
      case '401':
        return l10n?.invalidPhoneNumberOrPassword ?? 'Invalid phone number or password. Please check your credentials and try again.';
      case '403':
        return l10n?.youDoNotHavePermissionToPerformThisAction ?? 'You do not have permission to perform this action.';
      case '404':
        return l10n?.theRequestedResourceWasNotFound ?? 'The requested resource was not found.';
      case '500':
      case '502':
      case '503':
        return l10n?.serverError ?? 'Server error. Please try again later.';
      default:
        // If message is still technical, return generic message
        if (isTechnicalError(message)) {
          return l10n?.somethingWentWrong ?? 'Something went wrong. Please try again.';
        }
        return message.isEmpty ? (l10n?.somethingWentWrong ?? 'Something went wrong. Please try again.') : message;
    }
  }

  /// Parses non_field_errors format
  static String _parseNonFieldErrors(String errorString, AppLocalizations? l10n) {
    // Extract the actual error message from non_field_errors
    final nonFieldMatch = RegExp(r'non_field_errors:\s*\[([^\]]+)\]').firstMatch(errorString);
    if (nonFieldMatch != null) {
      String message = nonFieldMatch.group(1) ?? '';
      message = message.replaceAll('"', '').trim();
      
      // Convert common technical messages
      if (message.toLowerCase().contains('invalid credentials')) {
        return l10n?.invalidPhoneNumberOrPassword ?? 'Invalid phone number or password. Please check your credentials and try again.';
      }
      
      return message.isEmpty ? (l10n?.invalidInput ?? 'Invalid input. Please check your information and try again.') : message;
    }

    // If we can't parse it, return generic message
    return l10n?.invalidInput ?? 'Invalid input. Please check your information and try again.';
  }

  /// Parses bad request errors (400)
  static String _parseBadRequestError(String errorString, AppLocalizations? l10n) {
    // Remove technical prefixes
    String message = errorString
        .replaceAll(RegExp(r'HTTP \d+:\s*'), '')
        .replaceAll(RegExp(r'\([^)]*\)'), '')
        .trim();

    // Handle common bad request scenarios
    if (message.toLowerCase().contains('invalid credentials') ||
        message.toLowerCase().contains('authentication failed')) {
      return l10n?.invalidPhoneNumberOrPassword ?? 'Invalid phone number or password. Please check your credentials and try again.';
    }

    // Only convert to generic message if it's a technical/unspecific error
    // Don't convert specific error messages like "Invalid OTP" or "OTP expired"
    if (message.toLowerCase() == 'invalid' ||
        message.toLowerCase() == 'validation error' ||
        message.toLowerCase() == 'invalid input' ||
        (message.toLowerCase().contains('validation') && message.toLowerCase().contains('error'))) {
      return l10n?.invalidInput ?? 'Invalid input. Please check your information and try again.';
    }

    if (message.toLowerCase().contains('required') ||
        message.toLowerCase().contains('missing')) {
      return l10n?.pleaseFillInAllRequiredFields ?? 'Please fill in all required fields.';
    }

    // If message is still technical, return generic message
    if (isTechnicalError(message)) {
      return l10n?.invalidInput ?? 'Invalid input. Please check your information and try again.';
    }

    // Return the original message if it's user-friendly
    return message.isEmpty ? (l10n?.invalidInput ?? 'Invalid input. Please check your information and try again.') : message;
  }

  /// Parses field-specific errors
  static String _parseFieldErrors(String errorString) {
    // Remove technical prefixes
    String message = errorString
        .replaceAll(RegExp(r'HTTP \d+:\s*'), '')
        .trim();

    // Extract field errors (format: "field: error message")
    final fieldErrorMatch = RegExp(r'(\w+):\s*([^,]+)').firstMatch(message);
    if (fieldErrorMatch != null) {
      String fieldName = fieldErrorMatch.group(1) ?? '';
      String errorMsg = fieldErrorMatch.group(2) ?? '';
      
      // Convert field names to user-friendly labels
      fieldName = _getFieldLabel(fieldName);
      
      // Clean up error message
      errorMsg = errorMsg.replaceAll(RegExp(r'\[[^\]]*\]'), '').trim();
      errorMsg = errorMsg.replaceAll('"', '').trim();
      
      return '$fieldName: $errorMsg';
    }

    return message;
  }

  /// Converts technical field names to user-friendly labels
  static String _getFieldLabel(String fieldName) {
    final fieldLabels = {
      'phone': 'Phone number',
      'phone_number': 'Phone number',
      'password': 'Password',
      'email': 'Email',
      'first_name': 'First name',
      'last_name': 'Last name',
      'confirm_password': 'Confirm password',
      'new_password': 'New password',
      'current_password': 'Current password',
      'otp': 'OTP code',
      'non_field_errors': '',
    };

    return fieldLabels[fieldName.toLowerCase()] ?? fieldName;
  }

  /// Checks if an error message contains technical terms
  static bool isTechnicalError(String message) {
    final technicalTerms = [
      'HTTP',
      'status code',
      'statusCode',
      'non_field_errors',
      'field_errors',
      'Exception',
      'Error:',
      'stack trace',
      'at ',
      'dio',
      'DioException',
    ];

    return technicalTerms.any((term) => message.toLowerCase().contains(term.toLowerCase()));
  }

  /// Translates common English error messages to localized versions
  static String? _translateCommonErrorMessage(String errorString, AppLocalizations? l10n) {
    if (l10n == null) return null;
    
    final lowerError = errorString.toLowerCase().trim();
    
    // Authentication/Login errors
    if (lowerError.contains('invalid credentials') ||
        lowerError.contains('invalid phone number or password') ||
        lowerError.contains('authentication failed') ||
        lowerError.contains('login failed') ||
        lowerError.contains('unauthorized') ||
        lowerError.contains('wrong password') ||
        lowerError.contains('incorrect password') ||
        lowerError.contains('incorrect phone') ||
        lowerError.contains('user not found') ||
        lowerError.contains('account not found')) {
      return l10n.invalidPhoneNumberOrPassword;
    }
    
    // Phone number errors
    if (lowerError.contains('phone number is required') ||
        lowerError.contains('phone is required') ||
        lowerError.contains('phone number required') ||
        lowerError.contains('phone required') ||
        lowerError.contains('contact number is required') ||
        lowerError.contains('contact is required')) {
      return l10n.phoneNumberIsRequired;
    }
    
    if (lowerError.contains('please enter a valid phone number') ||
        lowerError.contains('invalid phone number') ||
        lowerError.contains('invalid phone') ||
        lowerError.contains('invalid phone number format') ||
        lowerError.contains('phone number format') ||
        lowerError.contains('valid phone number')) {
      return l10n.pleaseEnterAValidPhoneNumber;
    }
    
    // Password errors
    if (lowerError.contains('password is required') ||
        lowerError.contains('password required')) {
      return l10n.passwordRequired;
    }
    
    if (lowerError.contains('password must be at least') ||
        lowerError.contains('password too short') ||
        lowerError.contains('password length')) {
      return l10n.passwordMinLength;
    }
    
    // Email errors
    if (lowerError.contains('email is required') ||
        lowerError.contains('email required')) {
      return l10n.emailIsRequired;
    }
    
    if (lowerError.contains('please enter a valid email') ||
        lowerError.contains('invalid email') ||
        lowerError.contains('valid email address') ||
        lowerError.contains('email format')) {
      return l10n.pleaseEnterAValidEmailAddress;
    }
    
    // Network/Connection errors
    if (lowerError.contains('connection timeout') ||
        lowerError.contains('timeout') ||
        lowerError.contains('request timeout')) {
      return l10n.connectionTimeout;
    }
    
    if (lowerError.contains('network error') ||
        lowerError.contains('no internet') ||
        lowerError.contains('connection failed') ||
        lowerError.contains('no connection') ||
        lowerError.contains('internet connection')) {
      return l10n.networkError;
    }
    
    // Server errors
    if (lowerError.contains('server error') ||
        lowerError.contains('500') ||
        lowerError.contains('502') ||
        lowerError.contains('503') ||
        lowerError.contains('internal server error')) {
      return l10n.serverError;
    }
    
    // Not found errors
    if (lowerError.contains('not found') ||
        lowerError.contains('404') ||
        lowerError.contains('resource not found')) {
      return l10n.theRequestedResourceWasNotFound;
    }
    
    // Permission errors
    if (lowerError.contains('forbidden') ||
        lowerError.contains('403') ||
        lowerError.contains('permission denied') ||
        lowerError.contains('access denied')) {
      return l10n.youDoNotHavePermissionToPerformThisAction;
    }
    
    // Validation errors
    if (lowerError.contains('invalid input') ||
        lowerError.contains('validation error') ||
        lowerError.contains('invalid data')) {
      return l10n.invalidInput;
    }
    
    if (lowerError.contains('please fill in all required fields') ||
        lowerError.contains('required fields') ||
        lowerError.contains('all fields are required') ||
        lowerError.contains('missing required')) {
      return l10n.pleaseFillInAllRequiredFields;
    }
    
    // OTP errors
    if (lowerError.contains('invalid otp') ||
        lowerError.contains('otp is required') ||
        lowerError.contains('otp required') ||
        lowerError.contains('verification code') ||
        lowerError.contains('code is invalid') ||
        lowerError.contains('otp verification failed') ||
        lowerError.contains('invalid verification code') ||
        lowerError.contains('otp expired') ||
        lowerError.contains('code expired')) {
      return l10n.pleaseEnterTheComplete6DigitCode;
    }
    
    // Password reset errors
    if (lowerError.contains('password reset failed') ||
        lowerError.contains('reset password failed') ||
        lowerError.contains('failed to reset password') ||
        lowerError.contains('unable to reset password') ||
        lowerError.contains('could not reset password')) {
      return l10n.failedToChangePassword; // Using similar error message
    }
    
    // Forgot password errors
    if (lowerError.contains('forgot password failed') ||
        lowerError.contains('password reset request failed') ||
        lowerError.contains('failed to send verification code') ||
        lowerError.contains('unable to send verification code') ||
        lowerError.contains('could not send verification code') ||
        lowerError.contains('verification code not sent')) {
      return l10n.somethingWentWrong;
    }
    
    // User/Account not found errors - for forgot password specifically
    if (lowerError.contains('user not found') ||
        lowerError.contains('account not found') ||
        lowerError.contains('phone number not registered') ||
        lowerError.contains('contact number not found') ||
        lowerError.contains('phone not registered') ||
        lowerError.contains('phone number is not registered') ||
        lowerError.contains('contact number is not registered') ||
        lowerError.contains('this phone number is not registered') ||
        lowerError.contains('this contact number is not registered') ||
        lowerError.contains('phone number does not exist') ||
        lowerError.contains('contact number does not exist') ||
        lowerError.contains('no account found') ||
        lowerError.contains('no user found') ||
        lowerError.contains('phone number not found in our system') ||
        lowerError.contains('contact not registered') ||
        lowerError.contains('number not registered')) {
      // For forgot password flow, this is a specific error
      // We can use a generic message or add a specific translation key
      // For now, using a user-friendly message
      return l10n.invalidPhoneNumberOrPassword; // Generic authentication error
    }
    
    // Password mismatch errors
    if (lowerError.contains('password mismatch') ||
        lowerError.contains('passwords do not match') ||
        lowerError.contains('password confirmation') ||
        lowerError.contains('confirm password')) {
      return l10n.passwordsDoNotMatch;
    }
    
    // Password too weak errors
    if (lowerError.contains('password too weak') ||
        lowerError.contains('weak password') ||
        lowerError.contains('password strength')) {
      return l10n.passwordMustBeAtLeast8Characters;
    }
    
    // Generic error fallbacks
    if (lowerError.contains('an error occurred') ||
        lowerError.contains('error occurred') ||
        lowerError.contains('something went wrong') ||
        lowerError.contains('unexpected error')) {
      return l10n.anUnexpectedErrorOccurred;
    }
    
    if (lowerError.contains('failed') && 
        !lowerError.contains('authentication failed') &&
        !lowerError.contains('login failed')) {
      // Generic "failed" message - try to be more specific if possible
      if (lowerError.contains('request failed') ||
          lowerError.contains('operation failed')) {
        return l10n.somethingWentWrong;
      }
    }
    
    return null;
  }
}


