import 'package:flutter_test/flutter_test.dart';
import 'package:string_calculator/models/negative_number_exception.dart';
import 'package:string_calculator/string_calculator.dart';

void main() {
  group('StringCalculator.add — base kata', () {
    late StringCalculator calc;

    setUp(() {
      calc = StringCalculator();
    });

    test('empty -> 0', () {
      expect(calc.add(''), 0);
      expect(calc.add('   '), 0);
    });

    test('single number', () {
      expect(calc.add('1'), 1);
    });

    test('two numbers (comma)', () {
      expect(calc.add('1,5'), 6);
    });

    test('any amount of numbers', () {
      expect(calc.add('1,2,3,4,5'), 15);
    });

    test('newlines as delimiter', () {
      expect(calc.add('1\n2,3'), 6);
    });

    test('custom single-char delimiter', () {
      expect(calc.add('//;\n1;2'), 3);
    });

    test('negative throws with all listed', () {
      expect(
        () => calc.add('1,-2,3,-4'),
        throwsA(isA<NegativeNumberException>()),
      );
      try {
        calc.add('1,-2,3,-4');
        fail('Expected NegativeNumberException');
      } on NegativeNumberException catch (e) {
        expect(e.negatives, [-2, -4]);
        expect(e.toString(), 'negative numbers are not allowed -2,-4');
      }
    });

    test('ignore numbers > 1000', () {
      expect(calc.add('2,1001'), 2);
      expect(calc.add('1000,1'), 1001);
    });

    test('single custom delimiter of any length: //[***]\\n', () {
      expect(calc.add('//[***]\n1***2***3'), 6);
    });

    test('multiple custom delimiters: //[*][%]\\n', () {
      expect(calc.add('//[*][%]\n1*2%3'), 6);
    });

    test('multiple multi-char delimiters: // [***] [%%] \\n', () {
      expect(calc.add('//[***][%%]\n1***2%%3'), 6);
      expect(calc.add('//[abc][XYZ]\n4abc5XYZ6'), 15);
    });

    test('custom header also still accepts newline as delimiter', () {
      expect(calc.add('//[;]\n1;2\n3'), 6);
    });

    test('single custom delimiter without brackets (multi-char)', () {
      expect(calc.add('//***\n1***2***3'), 6);
    });

    test(
      'custom single-char delimiter with literal \\n sequence (raw string)',
      () {
        final calc = StringCalculator();
        expect(calc.add(r'//;\n1;2'), 3);
      },
    );

    test('custom delimiter header with CRLF \\r\\n still works', () {
      final calc = StringCalculator();
      expect(calc.add('//;\r\n1;2;1001'), 3);
    });
  });
}
