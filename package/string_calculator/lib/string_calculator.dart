library;

import 'package:string_calculator/models/negative_number_exception.dart';

class StringCalculator {
  int add(String numbers) {
    if (numbers.trim().isEmpty) return 0;

    String? customDelimiter;
    String payload = numbers;

    if (numbers.startsWith('//')) {
      final newlineIndex = numbers.indexOf('\n');
      if (newlineIndex == -1) {
        throw FormatException('Invalid custom delimiter header. Expected \\n.');
      }
      customDelimiter = numbers.substring(2, newlineIndex);
      payload = numbers.substring(newlineIndex + 1);
    }

    final delimiters = <String>[
      if (customDelimiter != null && customDelimiter.isNotEmpty)
        RegExp.escape(customDelimiter),
      ',',
      r'\n',
    ];

    final splitter = RegExp('(${delimiters.join('|')})');

    final parts =
        payload
            .split(splitter)
            .where((s) => s.isNotEmpty && !splitter.hasMatch(s))
            .toList();

    final values = <int>[];
    final negatives = <int>[];

    for (final part in parts) {
      final v = int.parse(part.trim());
      if (v > 0) {
        values.add(v);
      } else {
        negatives.add(v);
      }
    }

    if (negatives.isNotEmpty) {
      throw NegativeNumberException(negatives);
    }

    return values.fold<int>(0, (sum, v) => sum + v);
  }
}
