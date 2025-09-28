class InputValidators {
  static const String delimiterErrorMessage = 'Invalid delimiter';
  static String? validateRaw(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;

    if (s.startsWith('//')) {
      final idx = s.indexOf('\n');
      if (idx == -1) {
        return delimiterErrorMessage;
      }
      if (idx <= 2) {
        return 'Delimiter cannot be Empty.';
      }
    }
    return null;
  }

  static String? validateDelimiter(String d) {
    if (d.isEmpty) return null;
    if (d.contains('\n')) {
      return delimiterErrorMessage;
    }

    if (d.startsWith('[')) {
      final open = RegExp(r'\[').allMatches(d).length;
      final close = RegExp(r'\]').allMatches(d).length;
      if (open == 0 || open != close) {
        return delimiterErrorMessage;
      }
      if (!RegExp(r'^\[(?:[^\]]+)\](\[(?:[^\]]+)\])*?$').hasMatch(d)) {
        {
          return delimiterErrorMessage;
        }
      }
    }
    return null;
  }

  static String? validateNumbers(String numbers) {
    if (numbers.trim().isEmpty) return null;
    final ok = RegExp(r'^[0-9,\n\s-]+$').hasMatch(numbers);
    if (!ok) {
      return 'Invalid Number Format';
    }
    return null;
  }
}
