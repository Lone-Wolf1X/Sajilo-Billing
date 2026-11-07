import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/utils/nepali_validators.dart';

void main() {
  group('Nepali Validators Test', () {
    test('Nepali PAN validation', () {
      expect(NepaliValidators.validatePanVat('123456789'), isNull);
      expect(NepaliValidators.validatePanVat('12345'), isNotNull);
      expect(NepaliValidators.validatePanVat('12345678A'), isNotNull);
      expect(NepaliValidators.validatePanVat(''), isNotNull);
    });

    test('Nepali Contact mobile validation', () {
      expect(NepaliValidators.validateContactNumber('9841234567'), isNull);
      expect(NepaliValidators.validateContactNumber('9741234567'), isNull);
      expect(NepaliValidators.validateContactNumber('9641234567'), isNull);
      expect(NepaliValidators.validateContactNumber('9541234567'), isNotNull);
      expect(NepaliValidators.validateContactNumber('984123456'), isNotNull);
    });
  });
}
