import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_kata/main.dart';
import 'package:tdd_kata/presentation/calculator/calculator_screen.dart';

void main() {
  testWidgets('App renders calculator screen', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(CalculatorScreen), findsOneWidget);
  });
}
