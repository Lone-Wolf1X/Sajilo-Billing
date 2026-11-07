/// Nepali business and phone validation utilities.
class NepaliValidators {
  NepaliValidators._();

  /// Validates business / shop name.
  static String? validateBusinessName(String? value, {String? requiredMsg}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'Business name is required';
    }
    return null;
  }

  /// Validates Nepali PAN/VAT number (must be exactly 9 digits).
  static String? validatePanVat(
    String? value, {
    String? requiredMsg,
    String? invalidMsg,
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'PAN / VAT number is required';
    }
    final trimmed = value.trim();
    final panRegex = RegExp(r'^\d{9}$');
    if (!panRegex.hasMatch(trimmed)) {
      return invalidMsg ?? 'PAN must be exactly 9 digits';
    }
    return null;
  }

  /// Validates Nepali contact mobile number:
  /// Exactly 10 digits starting with 98, 97, or 96 (NTC, Ncell, Smart Cell).
  static String? validateContactNumber(
    String? value, {
    String? requiredMsg,
    String? invalidMsg,
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'Contact number is required';
    }
    final trimmed = value.trim().replaceAll(RegExp(r'[\s\-]'), '');
    final mobileRegex = RegExp(r'^(98|97|96)\d{8}$');
    if (!mobileRegex.hasMatch(trimmed)) {
      return invalidMsg ??
          'Contact number must be a 10-digit Nepali mobile (starts with 98, 97, or 96)';
    }
    return null;
  }
}

