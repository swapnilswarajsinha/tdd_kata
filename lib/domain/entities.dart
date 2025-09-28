import 'package:equatable/equatable.dart';

enum InputMode { compose, raw }

class CalculationRequest extends Equatable {
  final InputMode mode;
  final String delimiter;
  final String numbers;
  final String rawInput;
  const CalculationRequest({
    required this.mode,
    this.delimiter = '',
    this.numbers = '',
    this.rawInput = '',
  });

  @override
  List<Object?> get props => [mode, delimiter, numbers, rawInput];
}

class CalculationResult extends Equatable {
  final int sum;
  const CalculationResult(this.sum);

  @override
  List<Object?> get props => [sum];
}
