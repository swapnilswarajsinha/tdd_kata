import 'package:string_calculator/string_calculator.dart' as kata;
import '../domain/ports.dart';

class StringCalculatorAdapter implements CalculatorPort {
  final kata.StringCalculator _inner;
  StringCalculatorAdapter({kata.StringCalculator? inner})
    : _inner = inner ?? kata.StringCalculator();

  @override
  int add(String input) => _inner.add(input);
}
