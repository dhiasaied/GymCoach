/// Form validation rules ported from js/gymcoach.js.
class Validators {
  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$', caseSensitive: false);
  static final _nameRe = RegExp(r"^[a-zA-ZÀ-ÿ\s'.-]{2,60}$");

  static String? email(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required.';
    if (!_emailRe.hasMatch(v)) return 'Enter a valid email address.';
    return null;
  }

  static String? loginPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required.';
    if (v.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required.';
    if (v.length < minLength) {
      return 'Password must be at least $minLength characters.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(v)) {
      return 'Include at least one uppercase letter.';
    }
    if (!RegExp(r'[a-z]').hasMatch(v)) {
      return 'Include at least one lowercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(v)) {
      return 'Include at least one number.';
    }
    return null;
  }

  static String? name(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Full name is required.';
    if (!_nameRe.hasMatch(v)) {
      return 'Enter a valid name (2–60 characters, letters only).';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) return 'Please confirm your password.';
    if (value != password) return 'Passwords do not match.';
    return null;
  }

  static String? terms(bool? checked) {
    if (checked != true) {
      return 'You must accept the Terms of Service and Privacy Policy.';
    }
    return null;
  }

  static String? captchaVerified(bool? checked) {
    if (checked != true) return 'Please confirm you are not a robot.';
    return null;
  }

  static String? captchaAnswer(String? value, String expected) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Please enter the captcha code.';
    if (v != expected) return 'Incorrect captcha. Try again.';
    return null;
  }

  static String? chatMessage(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Enter a message for your coach.';
    if (v.length < 2) return 'Message must be at least 2 characters.';
    if (v.length > 500) return 'Message must be 500 characters or fewer.';
    return null;
  }

  static String? weight(String? value) {
    final v = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (v == null) return 'Enter a valid weight.';
    if (v < 30 || v > 300) return 'Weight must be between 30 and 300 kg.';
    return null;
  }

  static String? height(String? value) {
    final v = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (v == null) return 'Enter a valid height.';
    if (v < 100 || v > 250) return 'Height must be between 100 and 250 cm.';
    return null;
  }
}

class PasswordStrength {
  final int percent;
  final String label;
  final ColorToken colorToken;

  const PasswordStrength({
    required this.percent,
    required this.label,
    required this.colorToken,
  });

  static PasswordStrength evaluate(String value) {
    var strength = 0;
    if (value.isNotEmpty) strength = 20;
    if (value.length > 5) strength = 40;
    if (value.length > 8) strength = 70;
    if (RegExp(r'[A-Z]').hasMatch(value) &&
        RegExp(r'[0-9]').hasMatch(value) &&
        value.length > 10) {
      strength = 100;
    }

    if (strength <= 20) {
      return PasswordStrength(
        percent: strength,
        label: value.isEmpty ? 'Enter password' : 'Weak Protocol',
        colorToken: ColorToken.error,
      );
    }
    if (strength <= 70) {
      return PasswordStrength(
        percent: strength,
        label: 'Moderate Security',
        colorToken: ColorToken.tertiary,
      );
    }
    return PasswordStrength(
      percent: strength,
      label: 'Elite Encryption',
      colorToken: ColorToken.primary,
    );
  }
}

enum ColorToken { error, tertiary, primary }
