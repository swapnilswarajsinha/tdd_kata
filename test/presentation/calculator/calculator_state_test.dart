import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_kata/core/validator.dart';
import 'package:tdd_kata/domain/entities.dart';
import 'package:tdd_kata/presentation/calculator/bloc/calculator_state.dart';

void main() {
  group('CalculatorState.recalcPreview', () {
    test('returns raw input unchanged in raw mode', () {
      const state = CalculatorState(
        mode: InputMode.raw,
        rawInput: '//;\n1;2',
      );

      final next = CalculatorState.recalcPreview(state);
      expect(next.preview, '//;\n1;2');
    });

    test('uses comma join when delimiter empty', () {
      const state = CalculatorState(
        mode: InputMode.compose,
        numbers: '1\n2, 3',
      );

      final next = CalculatorState.recalcPreview(state);
      expect(next.preview, '1,2,3');
    });

    test('builds custom delimiter header', () {
      const state = CalculatorState(
        mode: InputMode.compose,
        delimiter: '@',
        numbers: '1\n2,3',
      );

      final next = CalculatorState.recalcPreview(state);
      expect(next.preview, '//@\n1@2@3');
    });

    test('uses first delimiter in bracket list to join', () {
      const state = CalculatorState(
        mode: InputMode.compose,
        delimiter: '[***][%%]',
        numbers: '1\n2,3',
      );

      final next = CalculatorState.recalcPreview(state);
      expect(next.preview, '//[***][%%]\n1***2***3');
    });
  });

  group('CalculatorState.validateForMode', () {
    test('validates compose mode inputs', () {
      const state = CalculatorState(
        mode: InputMode.compose,
        delimiter: 'bad\n',
        numbers: '1,a',
      );

      final next = CalculatorState.validateForMode(state);

      expect(next.delimiterError, InputValidators.delimiterErrorMessage);
      expect(
        next.numbersError,
        'Invalid Number Format',
      );
      expect(next.rawError, isNull);
      expect(next.isValidCompose, isFalse);
    });

    test('validates raw mode input', () {
      const state = CalculatorState(
        mode: InputMode.raw,
        rawInput: '//\n1,2',
      );

      final next = CalculatorState.validateForMode(state);

      expect(next.rawError, 'Delimiter cannot be Empty.');
      expect(next.delimiterError, isNull);
      expect(next.numbersError, isNull);
      expect(next.isValidRaw, isFalse);
    });

    test('valid inputs report valid flags', () {
      const compose = CalculatorState(
        mode: InputMode.compose,
        delimiter: ';',
        numbers: '1,2',
      );
      final validatedCompose = CalculatorState.validateForMode(compose);
      expect(validatedCompose.isValidCompose, isTrue);

      const raw = CalculatorState(
        mode: InputMode.raw,
        rawInput: '//;\n1;2',
      );
      final validatedRaw = CalculatorState.validateForMode(raw);
      expect(validatedRaw.isValidRaw, isTrue);
    });
  });
}
