import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_part_app/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('returns null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
      });

      test('returns error for invalid email', () {
        expect(Validators.validateEmail('invalid-email'), isNotNull);
      });

      test('returns error for empty email', () {
        expect(Validators.validateEmail(''), isNotNull);
      });
    });

    group('validatePassword', () {
      test('returns null for valid password', () {
        expect(Validators.validatePassword('password123'), isNull);
      });

      test('returns error for short password', () {
        expect(Validators.validatePassword('short'), isNotNull);
      });

      test('returns error for empty password', () {
        expect(Validators.validatePassword(''), isNotNull);
      });
    });
  });
}

