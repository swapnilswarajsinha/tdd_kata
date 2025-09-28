import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_kata/domain/entities.dart';
import 'package:tdd_kata/presentation/calculator/bloc/calculator_bloc.dart';
import 'package:tdd_kata/presentation/calculator/calculator_screen.dart';

void main() {
  Future<void> pumpCalculator(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CalculatorScreen()));
  }

  testWidgets('shows compose inputs and updates preview', (tester) async {
    await pumpCalculator(tester);

    final delimiterField = find.byKey(const Key('delimiter-field'));
    final numbersField = find.byKey(const Key('numbers-field'));

    expect(delimiterField, findsOneWidget);
    expect(numbersField, findsOneWidget);

    await tester.enterText(delimiterField, '@');
    await tester.pumpAndSettle();

    await tester.enterText(numbersField, '1,2');
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('preview-text')),
      findsOneWidget,
    );
    expect(find.text('//@\\n1@2'), findsOneWidget);
  });

  testWidgets('calculates sum in compose mode', (tester) async {
    await pumpCalculator(tester);

    await tester.enterText(find.byKey(const Key('numbers-field')), '1,2,3');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('submit-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('result-text')), findsOneWidget);
    expect(find.text('Sum: 6'), findsOneWidget);
  });

  testWidgets('switches to raw mode and calculates sum', (tester) async {
    await pumpCalculator(tester);

    await tester.tap(find.text('Raw String'));
    await tester.pumpAndSettle();

    final rawField = find.byKey(const Key('raw-field'));
    expect(rawField, findsOneWidget);

    await tester.enterText(rawField, '//;\n1;2');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('submit-button')));
    await tester.pumpAndSettle();

    expect(find.text('Sum: 3'), findsOneWidget);
    expect(find.byKey(const Key('preview-text')), findsOneWidget);
    expect(find.text('//;\\n1;2'), findsOneWidget);
  });

  testWidgets('shows validation error for invalid raw header', (tester) async {
    await pumpCalculator(tester);

    await tester.tap(find.text('Raw String'));
    await tester.pumpAndSettle();

    final rawField = find.byKey(const Key('raw-field'));
    await tester.enterText(rawField, '//\n1,2');
    await tester.pumpAndSettle();

    final bloc = BlocProvider.of<CalculatorBloc>(tester.element(rawField));
    expect(bloc.state.mode, InputMode.raw);
    expect(bloc.state.rawInput, '//\n1,2');
    expect(bloc.state.rawError, 'Delimiter cannot be Empty.');
  });

  testWidgets('displays calculator error message', (tester) async {
    await pumpCalculator(tester);

    await tester.tap(find.text('Raw String'));
    await tester.pumpAndSettle();

    final rawField = find.byKey(const Key('raw-field'));
    await tester.enterText(rawField, '//;\n1;-2');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('submit-button')));
    await tester.pumpAndSettle();

    expect(
      find.text('negative numbers are not allowed -2'),
      findsOneWidget,
    );
  });
}
