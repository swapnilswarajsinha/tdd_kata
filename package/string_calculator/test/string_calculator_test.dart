import 'package:flutter_test/flutter_test.dart';
import 'package:string_calculator/models/negative_number_exception.dart';
import 'package:string_calculator/string_calculator.dart';

void main() {
  group('StringCalculator.add', () {
    late StringCalculator calc;

    setUp(() {
      calc = StringCalculator();
    });

    test('returns 0 for empty string', () {
      expect(calc.add(''), 0);
      expect(calc.add('  '), 0);
    });

    test('returns the number for single value', () {
      expect(calc.add('1'), 1);
      expect(calc.add('15'), 15);
    });

    test('sums two comma-separated numbers', () {
      expect(calc.add('1,5'), 6);
    });

    test('handles any amount of numbers', () {
      expect(calc.add('1,2,3,4,5'), 15);
      expect(calc.add('5,6,10'), 21);
    });

    test("supports newlines as delimiters", () {
      expect(calc.add('1\n2,3'), 6);
      expect(calc.add('4\n5\n6'), 15);
    });

    test('supports custom delimiter with //<delim>\\n header', () {
      expect(calc.add('//;\n1;2'), 3);
      expect(calc.add('//|\n10|20|30'), 60);
      expect(calc.add('//***\n1***2***3'), 6);
    });

    test('throws with all negative numbers listed', () {
      try {
        calc.add('1,-2,3,-4');
        fail('Expected NegativeNumberException');
      } on NegativeNumberException catch (e) {
        expect(e.negatives, [-2, -4]);
        expect(e.toString(), 'negative numbers are not allowed -2,-4');
      }
    });

    test('throws for negatives even with custom delimiter', () {
      expect(
        () => calc.add('//;\n-1;2;-3'),
        throwsA(isA<NegativeNumberException>()),
      );
      try {
        calc.add('//;\n-1;2;-3');
        fail('Expected NegativeNumberException');
      } on NegativeNumberException catch (e) {
        expect(e.negatives, [-1, -3]);
        expect(e.toString(), 'negative numbers are not allowed -1,-3');
      }
    });

    test('ignores delimiter tokens in split (no empty entries)', () {
      expect(calc.add('1,,2\n3'), 6);
    });
  });
}
