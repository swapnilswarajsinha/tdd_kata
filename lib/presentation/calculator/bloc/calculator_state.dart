import 'package:equatable/equatable.dart';
import '../../../core/validator.dart';
import '../../../domain/entities.dart';

class CalculatorState extends Equatable {
  final InputMode mode;
  final String delimiter;
  final String numbers;
  final String rawInput;

  final String? delimiterError;
  final String? numbersError;
  final String? rawError;

  final String preview;
  final int? result;
  final String? submitError;
  final bool isSubmitting;

  const CalculatorState({
    this.mode = InputMode.compose,
    this.delimiter = '',
    this.numbers = '',
    this.rawInput = '',
    this.delimiterError,
    this.numbersError,
    this.rawError,
    this.preview = '',
    this.result,
    this.submitError,
    this.isSubmitting = false,
  });

  bool get isValidCompose => delimiterError == null && numbersError == null;
  bool get isValidRaw => rawError == null;

  CalculatorState copyWith({
    InputMode? mode,
    String? delimiter,
    String? numbers,
    String? rawInput,
    String? delimiterError,
    String? numbersError,
    String? rawError,
    String? preview,
    int? result,
    String? submitError,
    bool? isSubmitting,
  }) {
    return CalculatorState(
      mode: mode ?? this.mode,
      delimiter: delimiter ?? this.delimiter,
      numbers: numbers ?? this.numbers,
      rawInput: rawInput ?? this.rawInput,
      delimiterError: delimiterError,
      numbersError: numbersError,
      rawError: rawError,
      preview: preview ?? this.preview,
      result: result,
      submitError: submitError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  static CalculatorState recalcPreview(CalculatorState s) {
    String preview;

    if (s.mode == InputMode.raw) {
      preview = s.rawInput;
    } else {
      final d = s.delimiter.trim();
      final parts =
          s.numbers
              .split(RegExp(r'[,\n]'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      if (d.isEmpty) {
        preview = parts.isEmpty ? '' : parts.join(',');
      } else {
        String header;
        String joinWith;
        if (d.startsWith('[')) {
          header = '//$d\n';
          final first = RegExp(r'\[([^\]]+)\]').firstMatch(d)?.group(1) ?? '';
          joinWith = first.isEmpty ? ',' : first;
        } else {
          header = '//$d\n';
          joinWith = d;
        }

        final body = parts.join(joinWith);
        preview = '$header$body';
      }
    }

    return s.copyWith(
      preview: preview,
      delimiterError: s.delimiterError,
      numbersError: s.numbersError,
      rawError: s.rawError,
    );
  }

  static CalculatorState validateForMode(CalculatorState s) {
    if (s.mode == InputMode.raw) {
      return s.copyWith(
        rawError: InputValidators.validateRaw(s.rawInput),
        delimiterError: null,
        numbersError: null,
      );
    } else {
      return s.copyWith(
        delimiterError: InputValidators.validateDelimiter(s.delimiter),
        numbersError: InputValidators.validateNumbers(s.numbers),
        rawError: null,
      );
    }
  }

  @override
  List<Object?> get props => [
    mode,
    delimiter,
    numbers,
    rawInput,
    delimiterError,
    numbersError,
    rawError,
    preview,
    result,
    submitError,
    isSubmitting,
  ];
}
