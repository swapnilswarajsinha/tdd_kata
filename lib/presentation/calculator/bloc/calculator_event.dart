import 'package:equatable/equatable.dart';
import '../../../domain/entities.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();
  @override
  List<Object?> get props => [];
}

class ModeChanged extends CalculatorEvent {
  final InputMode mode;
  const ModeChanged(this.mode);
  @override
  List<Object?> get props => [mode];
}

class DelimiterChanged extends CalculatorEvent {
  final String delimiter;
  const DelimiterChanged(this.delimiter);
  @override
  List<Object?> get props => [delimiter];
}

class NumbersChanged extends CalculatorEvent {
  final String numbers;
  const NumbersChanged(this.numbers);
  @override
  List<Object?> get props => [numbers];
}

class RawInputChanged extends CalculatorEvent {
  final String rawInput;
  const RawInputChanged(this.rawInput);
  @override
  List<Object?> get props => [rawInput];
}

class Submitted extends CalculatorEvent {
  const Submitted();
}
