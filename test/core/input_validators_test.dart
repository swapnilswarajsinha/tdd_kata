import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_kata/core/validator.dart';

void main() {
  group('InputValidators.validateRaw', () {
    test('returns null when input is empty', () {
      expect(InputValidators.validateRaw('   '), isNull);
    });

    test('returns error when custom delimiter header misses newline', () {
      expect(
        InputValidators.validateRaw('//;1,2,3'),
        InputValidators.delimiterErrorMessage,
      );
    });

    test('returns error when custom delimiter is empty', () {
      expect(
        InputValidators.validateRaw('//\n1,2,3'),
        'Delimiter cannot be Empty.',
      );
    });

    test('returns null for valid custom delimiter header', () {
      expect(InputValidators.validateRaw('//;\n1;2'), isNull);
    });
  });

  group('InputValidators.validateDelimiter', () {
    test('allows empty delimiter', () {
      expect(InputValidators.validateDelimiter(''), isNull);
    });

    test('rejects delimiter containing newline', () {
      expect(
        InputValidators.validateDelimiter('abc\n'),
        InputValidators.delimiterErrorMessage,
      );
    });

    test('rejects malformed bracketed delimiters', () {
      expect(
        InputValidators.validateDelimiter('[abc'),
        InputValidators.delimiterErrorMessage,
      );
    });

    test('rejects bracketed delimiter with empty value', () {
      expect(
        InputValidators.validateDelimiter('[]'),
        InputValidators.delimiterErrorMessage,
      );
    });

    test('accepts bracketed delimiter list', () {
      expect(InputValidators.validateDelimiter('[***][%%]'), isNull);
    });

    test('accepts simple delimiter string', () {
      expect(InputValidators.validateDelimiter('***'), isNull);
    });
  });

  group('InputValidators.validateNumbers', () {
    test('allows empty numbers input', () {
      expect(InputValidators.validateNumbers('   '), isNull);
    });

    test('accepts digits commas newlines spaces and minus signs', () {
      expect(InputValidators.validateNumbers('1, 2\n-3'), isNull);
    });

    test('rejects invalid characters', () {
      expect(
        InputValidators.validateNumbers('1,a,2'),
        'Invalid Number Format',
      );
    });
  });
}
