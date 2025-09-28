import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:string_calculator/string_calculator.dart' as kata;
import 'package:tdd_kata/infrastructure/string_calculator.dart';

class _MockStringCalculator extends Mock implements kata.StringCalculator {}

void main() {
  test('delegates to provided inner calculator', () {
    final inner = _MockStringCalculator();
    when(() => inner.add('1,2')).thenReturn(3);

    final adapter = StringCalculatorAdapter(inner: inner);
    final result = adapter.add('1,2');

    expect(result, 3);
    verify(() => inner.add('1,2')).called(1);
  });

  test('creates default inner calculator when not provided', () {
    final adapter = StringCalculatorAdapter();
    expect(adapter.add('1,2,3'), 6);
  });
}
