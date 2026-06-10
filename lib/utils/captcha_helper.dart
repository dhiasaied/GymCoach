import 'dart:math';

class CaptchaHelper {
  static const _upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
  static const _lower = 'abcdefghjkmnpqrstuvwxyz';
  static const _digits = '23456789';

  static String generate({int length = 6}) {
    final all = _upper + _lower + _digits;
    final chars = <String>[
      _upper[_random.nextInt(_upper.length)],
      _lower[_random.nextInt(_lower.length)],
      _digits[_random.nextInt(_digits.length)],
    ];
    while (chars.length < length) {
      chars.add(all[_random.nextInt(all.length)]);
    }
    chars.shuffle(_random);
    return chars.join();
  }

  static ColorForChar colorFor(String char) {
    if (RegExp(r'[A-Z]').hasMatch(char)) return ColorForChar.primary;
    if (RegExp(r'[a-z]').hasMatch(char)) return ColorForChar.tertiary;
    return ColorForChar.secondary;
  }

  static double rotationFor(String char) =>
      (_random.nextDouble() * 14 - 7);

  static final _random = Random();
}

enum ColorForChar { primary, tertiary, secondary }
