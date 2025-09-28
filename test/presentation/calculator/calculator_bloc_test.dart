import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_kata/core/validator.dart';
import 'package:tdd_kata/domain/entities.dart';
import 'package:tdd_kata/domain/usecases/sum_usecase.dart';
import 'package:tdd_kata/presentation/calculator/bloc/calculator_bloc.dart';
import 'package:tdd_kata/presentation/calculator/bloc/calculator_event.dart';
import 'package:tdd_kata/presentation/calculator/bloc/calculator_state.dart';

class _MockCalculateSumUseCase extends Mock implements CalculateSumUseCase {}

class _CalculationRequestFake extends Fake implements CalculationRequest {
  @override
  InputMode get mode => InputMode.compose;

  @override
  String get delimiter => '';

  @override
  String get numbers => '';

  @override
  String get rawInput => '';

  @override
  List<Object?> get props => const [];
}

void main() {
  setUpAll(() {
    registerFallbackValue(_CalculationRequestFake());
  });

  late _MockCalculateSumUseCase useCase;

  setUp(() {
    useCase = _MockCalculateSumUseCase();
  });

  blocTest<CalculatorBloc, CalculatorState>(
    'ModeChanged switches mode and recalculates preview',
    build: () => CalculatorBloc(useCase),
    act: (bloc) => bloc.add(const ModeChanged(InputMode.raw)),
    expect: () => const [CalculatorState(mode: InputMode.raw)],
  );

  blocTest<CalculatorBloc, CalculatorState>(
    'DelimiterChanged validates input and clears preview',
    build: () => CalculatorBloc(useCase),
    act: (bloc) => bloc.add(const DelimiterChanged('abc\n')),
    expect: () => const [
      CalculatorState(
        delimiter: 'abc\n',
        delimiterError: InputValidators.delimiterErrorMessage,
        preview: '//abc\n',
      ),
    ],
  );

  blocTest<CalculatorBloc, CalculatorState>(
    'NumbersChanged updates preview with comma join by default',
    build: () => CalculatorBloc(useCase),
    act: (bloc) => bloc.add(const NumbersChanged('1\n2,3')),
    expect: () => const [
      CalculatorState(
        numbers: '1\n2,3',
        preview: '1,2,3',
      ),
    ],
  );

  blocTest<CalculatorBloc, CalculatorState>(
    'RawInputChanged validates raw mode',
    build: () => CalculatorBloc(useCase),
    act: (bloc) {
      bloc
        ..add(const ModeChanged(InputMode.raw))
        ..add(const RawInputChanged('//\n1'));
    },
    expect: () => const [
      CalculatorState(mode: InputMode.raw),
      CalculatorState(
        mode: InputMode.raw,
        rawInput: '//\n1',
        rawError: 'Delimiter cannot be Empty.',
        preview: '//\n1',
      ),
    ],
  );

  blocTest<CalculatorBloc, CalculatorState>(
    'Submitted ignores compose submissions with validation errors',
    build: () => CalculatorBloc(useCase),
    seed: () => const CalculatorState(numbersError: 'bad input'),
    act: (bloc) => bloc.add(const Submitted()),
    expect: () => const <CalculatorState>[],
    verify: (_) => verifyNever(() => useCase(any())),
  );

  blocTest<CalculatorBloc, CalculatorState>(
    'Submitted emits loading then success result',
    build: () {
      when(() => useCase(any())).thenReturn(
        (result: const CalculationResult(3), error: null),
      );
      return CalculatorBloc(useCase);
    },
    seed: () => const CalculatorState(numbers: '1,2', preview: '1,2'),
    act: (bloc) => bloc.add(const Submitted()),
    expect: () => const [
      CalculatorState(numbers: '1,2', preview: '1,2', isSubmitting: true),
      CalculatorState(numbers: '1,2', preview: '1,2', result: 3),
    ],
    verify: (_) {
      final captured = verify(() => useCase(captureAny())).captured;
      expect(captured.single, isA<CalculationRequest>());
      final req = captured.single as CalculationRequest;
      expect(req.mode, InputMode.compose);
      expect(req.numbers, '1,2');
      expect(req.delimiter, '');
      expect(req.rawInput, '');
    },
  );

  blocTest<CalculatorBloc, CalculatorState>(
    'Submitted emits error when use case fails',
    build: () {
      when(() => useCase(any())).thenReturn(
        (result: null, error: 'boom'),
      );
      return CalculatorBloc(useCase);
    },
    seed: () => const CalculatorState(numbers: '1,2', preview: '1,2'),
    act: (bloc) => bloc.add(const Submitted()),
    expect: () => const [
      CalculatorState(numbers: '1,2', preview: '1,2', isSubmitting: true),
      CalculatorState(
        numbers: '1,2',
        preview: '1,2',
        submitError: 'boom',
      ),
    ],
  );
}
