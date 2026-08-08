import 'package:medcollab_app/core/constants/app_constants.dart';

abstract final class PhoneUtils {
  /// Indian mobile: 10 digits starting with 6–9.
  static final RegExp _localPattern = RegExp(r'^[6-9]\d{9}$');

  /// Backend expects E.164: `+919876543210`
  static final RegExp _e164Pattern = RegExp(r'^\+[1-9]\d{6,14}$');

  static String? validateLocalNumber(String? raw) {
    final digits = raw?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.isEmpty) return 'Phone number is required';
    if (digits.length != 10) return 'Enter a valid 10-digit mobile number';
    if (!_localPattern.hasMatch(digits)) {
      return 'Number must start with 6, 7, 8, or 9';
    }
    // Block obviously fake / repeated-digit numbers (e.g. 9999999999).
    if (RegExp(r'^(\d)\1{9}$').hasMatch(digits)) {
      return 'Enter a real mobile number, not a repeated-digit test number';
    }
    // Block simple ascending/descending sequences (e.g. 9876543210 is ok, but
    // 0123456789 already fails start rule; 1234567890 starts with 1).
    if (_isTrivialSequence(digits)) {
      return 'Enter a valid mobile number';
    }
    return null;
  }

  static bool _isTrivialSequence(String digits) {
    var ascending = true;
    var descending = true;
    for (var i = 1; i < digits.length; i++) {
      final prev = int.parse(digits[i - 1]);
      final curr = int.parse(digits[i]);
      if (curr != (prev + 1) % 10) ascending = false;
      if (curr != (prev + 9) % 10) descending = false;
    }
    return ascending || descending;
  }

  static String toE164(String localDigits) {
    final digits = localDigits.replaceAll(RegExp(r'\D'), '');
    return '${AppConstants.defaultCountryCode}$digits';
  }

  static String? validateOtp(String? raw) {
    final otp = raw?.trim() ?? '';
    if (otp.isEmpty) return 'OTP is required';
    if (otp.length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(otp)) return 'OTP must contain only digits';
    return null;
  }

  static String? validateE164(String? phone) {
    if (phone == null || phone.isEmpty) return 'Phone number is required';
    if (!_e164Pattern.hasMatch(phone)) return 'Invalid phone number format';
    return null;
  }

  /// Display `+91 98765 43210` from E.164.
  static String formatForDisplay(String e164) {
    if (!e164.startsWith(AppConstants.defaultCountryCode)) return e164;
    final local = e164.substring(AppConstants.defaultCountryCode.length);
    if (local.length != 10) return e164;
    return '${AppConstants.defaultCountryCode} ${local.substring(0, 5)} ${local.substring(5)}';
  }

  /// Extract a 6-char invite code from free text or a deep link /join/CODE URL.
  static String? extractInviteCode(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final fromUrl = RegExp(
      r'(?:join[\/#]|invite[=\/])([A-Za-z0-9]{4,12})',
      caseSensitive: false,
    ).firstMatch(trimmed);
    if (fromUrl != null) return fromUrl.group(1)!.toUpperCase();
    final onlyCode = RegExp(r'^[A-Za-z0-9]{4,12}$').firstMatch(trimmed);
    return onlyCode?.group(0)?.toUpperCase();
  }
}
