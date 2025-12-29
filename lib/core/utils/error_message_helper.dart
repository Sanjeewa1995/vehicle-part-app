/// Utility class to convert technical error messages to user-friendly messages
class ErrorMessageHelper {
  /// Converts technical error messages to user-friendly messages
  static String getUserFriendlyMessage(dynamic error) {
    if (error == null) {
      return 'An unexpected error occurred. Please try again.';
    }

    String errorString = error.toString();

    // Remove common exception prefixes
    errorString = errorString
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '')
        .trim();

    // Handle HTTP status codes and technical error formats
    if (errorString.contains('HTTP ')) {
      return _parseHttpError(errorString);
    }

    // Handle non_field_errors format
    if (errorString.contains('non_field_errors')) {
      return _parseNonFieldErrors(errorString);
    }

    // Handle common error patterns
    if (errorString.toLowerCase().contains('invalid credentials') ||
        errorString.toLowerCase().contains('authentication failed') ||
        errorString.toLowerCase().contains('unauthorized')) {
      return 'Invalid phone number or password. Please check your credentials and try again.';
    }

    if (errorString.toLowerCase().contains('connection timeout') ||
        errorString.toLowerCase().contains('timeout')) {
      return 'Connection timeout. Please check your internet connection and try again.';
    }

    if (errorString.toLowerCase().contains('network error') ||
        errorString.toLowerCase().contains('no internet') ||
        errorString.toLowerCase().contains('connection failed')) {
      return 'Network error. Please check your internet connection and try again.';
    }

    if (errorString.toLowerCase().contains('server error') ||
        errorString.toLowerCase().contains('500')) {
      return 'Server error. Please try again later.';
    }

    if (errorString.toLowerCase().contains('not found') ||
        errorString.toLowerCase().contains('404')) {
      return 'The requested resource was not found.';
    }

    if (errorString.toLowerCase().contains('bad request') ||
        errorString.toLowerCase().contains('400')) {
      return _parseBadRequestError(errorString);
    }

    if (errorString.toLowerCase().contains('forbidden') ||
        errorString.toLowerCase().contains('403')) {
      return 'You do not have permission to perform this action.';
    }

    // Handle field-specific errors
    if (errorString.contains(':')) {
      return _parseFieldErrors(errorString);
    }

    // If it's already a user-friendly message (doesn't contain technical terms), return as is
    if (!_isTechnicalError(errorString)) {
      return errorString;
    }

    // Default fallback
    return 'Something went wrong. Please try again.';
  }

  /// Parses HTTP error messages
  static String _parseHttpError(String errorString) {
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
        return _parseBadRequestError(message);
      case '401':
        return 'Invalid phone number or password. Please check your credentials and try again.';
      case '403':
        return 'You do not have permission to perform this action.';
      case '404':
        return 'The requested resource was not found.';
      case '500':
      case '502':
      case '503':
        return 'Server error. Please try again later.';
      default:
        // If message is still technical, return generic message
        if (_isTechnicalError(message)) {
          return 'Something went wrong. Please try again.';
        }
        return message.isEmpty ? 'Something went wrong. Please try again.' : message;
    }
  }

  /// Parses non_field_errors format
  static String _parseNonFieldErrors(String errorString) {
    // Extract the actual error message from non_field_errors
    final nonFieldMatch = RegExp(r'non_field_errors:\s*\[([^\]]+)\]').firstMatch(errorString);
    if (nonFieldMatch != null) {
      String message = nonFieldMatch.group(1) ?? '';
      message = message.replaceAll('"', '').trim();
      
      // Convert common technical messages
      if (message.toLowerCase().contains('invalid credentials')) {
        return 'Invalid phone number or password. Please check your credentials and try again.';
      }
      
      return message.isEmpty ? 'Invalid input. Please check your information and try again.' : message;
    }

    // If we can't parse it, return generic message
    return 'Invalid input. Please check your information and try again.';
  }

  /// Parses bad request errors (400)
  static String _parseBadRequestError(String errorString) {
    // Remove technical prefixes
    String message = errorString
        .replaceAll(RegExp(r'HTTP \d+:\s*'), '')
        .replaceAll(RegExp(r'\([^)]*\)'), '')
        .trim();

    // Handle common bad request scenarios
    if (message.toLowerCase().contains('invalid credentials') ||
        message.toLowerCase().contains('authentication failed')) {
      return 'Invalid phone number or password. Please check your credentials and try again.';
    }

    if (message.toLowerCase().contains('validation') ||
        message.toLowerCase().contains('invalid')) {
      return 'Invalid input. Please check your information and try again.';
    }

    if (message.toLowerCase().contains('required') ||
        message.toLowerCase().contains('missing')) {
      return 'Please fill in all required fields.';
    }

    // If message is still technical, return generic message
    if (_isTechnicalError(message)) {
      return 'Invalid input. Please check your information and try again.';
    }

    return message.isEmpty ? 'Invalid input. Please check your information and try again.' : message;
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
  static bool _isTechnicalError(String message) {
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
}

