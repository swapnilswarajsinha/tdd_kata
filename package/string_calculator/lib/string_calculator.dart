library;

import 'package:string_calculator/models/negative_number_exception.dart';

class StringCalculator {
  int add(String numbers) {
    final input = numbers.trim();
    if (input.isEmpty) return 0;

    String payload = input;
    List<String> delimiters;

    if (input.startsWith('//')) {
      int headerEnd = input.indexOf('\n');
      int sepLen = 1;

      if (headerEnd == -1) {
        headerEnd = input.indexOf('\r\n');
        if (headerEnd != -1) sepLen = 2;
      }
      if (headerEnd == -1) {
        final lit = input.indexOf(r'\n');
        if (lit != -1) {
          headerEnd = lit;
          sepLen = 2;
        }
      }
      if (headerEnd == -1) {
        throw FormatException('Invalid custom delimiter header. Expected \\n.');
      }

      final rawHeader = input.substring(2, headerEnd);
      final header = rawHeader.replaceAll('\r', '');

      payload = input.substring(headerEnd + sepLen);

      delimiters = _parseDelimiters(header);
      delimiters.add(r'\n');
    } else {
      delimiters = [',', r'\n'];
    }

    final delimPattern = RegExp('(${delimiters.join('|')})');

    final tokens =
        payload
            .split(delimPattern)
            .where((s) => s.isNotEmpty && !delimPattern.hasMatch(s))
            .toList();

    final values = <int>[];
    final negatives = <int>[];

    for (final t in tokens) {
      final v = int.parse(t.trim());
      if (v < 0) {
        negatives.add(v);
      } else if (v <= 1000) {
        values.add(v);
      }
    }

    if (negatives.isNotEmpty) {
      throw NegativeNumberException(negatives);
    }

    return values.fold<int>(0, (sum, v) => sum + v);
  }

  static List<String> _parseDelimiters(String header) {
    if (header.startsWith('[')) {
      final matches = RegExp(r'\[([^\]]+)\]').allMatches(header);
      final list = matches.map((m) => m.group(1)!).toList();
      if (list.isEmpty) {
        throw FormatException('Delimiter list cannot be empty.');
      }
      return list.map(RegExp.escape).toList();
    } else {
      if (header.isEmpty) {
        throw FormatException('Delimiter cannot be empty.');
      }
      return [RegExp.escape(header)];
    }
  }
}
