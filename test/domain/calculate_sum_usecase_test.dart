import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_kata/domain/entities.dart';
import 'package:tdd_kata/domain/ports.dart';
import 'package:tdd_kata/domain/usecases/sum_usecase.dart';

class _MockCalculatorPort extends Mock implements CalculatorPort {}

void main() {
  late _MockCalculatorPort mock;
  late CalculateSumUseCase useCase;

  setUp(() {
    mock = _MockCalculatorPort();
    useCase = CalculateSumUseCase(mock);
  });

  test('compose mode delegates numbers when delimiter empty', () {
    when(() => mock.add('1,2')).thenReturn(3);

    final result = useCase(
      const CalculationRequest(mode: InputMode.compose, numbers: '1,2'),
    );

    expect(result.error, isNull);
    expect(result.result?.sum, 3);
    verify(() => mock.add('1,2')).called(1);
  });

  test('compose mode builds payload with custom delimiter', () {
    when(() => mock.add('//***\n1***2***3')).thenReturn(6);

    final result = useCase(
      const CalculationRequest(
        mode: InputMode.compose,
        delimiter: '***',
        numbers: '1\n2,3',
      ),
    );

    expect(result.error, isNull);
    expect(result.result?.sum, 6);
    verify(() => mock.add('//***\n1***2***3')).called(1);
  });

  test('raw mode trims payload before delegating', () {
    when(() => mock.add('//;\n1;2')).thenReturn(3);

    final result = useCase(
      const CalculationRequest(
        mode: InputMode.raw,
        rawInput: '  //;\n1;2  ',
      ),
    );

    expect(result.error, isNull);
    expect(result.result?.sum, 3);
    verify(() => mock.add('//;\n1;2')).called(1);
  });

  test('propagates calculator exception as error message', () {
    when(() => mock.add(any())).thenThrow(const FormatException('bad delimiter'));

    final result = useCase(
      const CalculationRequest(
        mode: InputMode.raw,
        rawInput: '//\n1',
      ),
    );

    expect(result.result, isNull);
    expect(result.error, 'FormatException: bad delimiter');
  });
}
