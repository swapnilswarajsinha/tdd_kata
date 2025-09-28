import '../entities.dart';
import '../ports.dart';

class CalculateSumUseCase {
  final CalculatorPort calculator;

  CalculateSumUseCase(this.calculator);

  ({CalculationResult? result, String? error}) call(CalculationRequest req) {
    final input = switch (req.mode) {
      InputMode.raw => req.rawInput.trim(),
      InputMode.compose => _composeInput(req.delimiter, req.numbers),
    };

    try {
      final sum = calculator.add(input);
      return (result: CalculationResult(sum), error: null);
    } on Exception catch (e) {
      return (result: null, error: e.toString());
    }
  }

  String _composeInput(String delimiter, String numbers) {
    final d = delimiter;
    if (d.isEmpty) {
      return numbers;
    }
    final parts =
        numbers
            .split(RegExp(r'[,\n]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
    final joined = parts.join(d);
    return '//$d\n$joined';
  }
}
