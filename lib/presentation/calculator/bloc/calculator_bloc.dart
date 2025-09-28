import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities.dart';
import '../../../domain/usecases/sum_usecase.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final CalculateSumUseCase useCase;

  CalculatorBloc(this.useCase) : super(CalculatorState()) {
    on<ModeChanged>((e, emit) {
      final next = CalculatorState(
        mode: e.mode,
        delimiter: e.mode == InputMode.compose ? state.delimiter : '',
        numbers: e.mode == InputMode.compose ? state.numbers : '',
        rawInput: e.mode == InputMode.raw ? state.rawInput : '',
        result: null,
      );
      final validated = CalculatorState.validateForMode(next);
      emit(CalculatorState.recalcPreview(validated));
    });

    on<DelimiterChanged>((e, emit) {
      var next = state.copyWith(delimiter: e.delimiter, result: null);
      next = CalculatorState.validateForMode(next);
      emit(CalculatorState.recalcPreview(next));
    });

    on<NumbersChanged>((e, emit) {
      var next = state.copyWith(numbers: e.numbers, result: null);
      next = CalculatorState.validateForMode(next);
      emit(CalculatorState.recalcPreview(next));
    });

    on<RawInputChanged>((e, emit) {
      var next = state.copyWith(rawInput: e.rawInput, result: null);
      next = CalculatorState.validateForMode(next);
      emit(CalculatorState.recalcPreview(next));
    });

    on<Submitted>((e, emit) async {
      if (state.mode == InputMode.compose && !state.isValidCompose) return;
      if (state.mode == InputMode.raw && !state.isValidRaw) return;

      emit(state.copyWith(isSubmitting: true, submitError: null));
      final req = CalculationRequest(
        mode: state.mode,
        delimiter: state.delimiter,
        numbers: state.numbers,
        rawInput: state.rawInput,
      );

      final out = useCase(req);
      if (out.error != null) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitError: out.error,
            result: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitError: null,
            result: out.result?.sum,
          ),
        );
      }
    });
  }
}
