import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_kata/presentation/calculator/bloc/calculator_bloc.dart';
import 'package:tdd_kata/presentation/calculator/bloc/calculator_event.dart';
import '../../domain/entities.dart';
import '../../domain/usecases/sum_usecase.dart';
import '../../infrastructure/string_calculator.dart';
import 'bloc/calculator_state.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => CalculatorBloc(CalculateSumUseCase(StringCalculatorAdapter())),
      child: const _CalculatorView(),
    );
  }
}

class _CalculatorView extends StatelessWidget {
  const _CalculatorView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CalculatorBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('String Calculator')),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: BlocBuilder<CalculatorBloc, CalculatorState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedButton<InputMode>(
                    segments: const [
                      ButtonSegment(
                        value: InputMode.compose,
                        label: Text('Compose'),
                      ),
                      ButtonSegment(
                        value: InputMode.raw,
                        label: Text('Raw String'),
                      ),
                    ],
                    selected: {state.mode},
                    onSelectionChanged: (s) => bloc.add(ModeChanged(s.first)),
                  ),
                  const SizedBox(height: 16),
                  if (state.mode == InputMode.compose) ...[
                    Text(
                      'Delimiter',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      key: const Key('delimiter-field'),
                      decoration: InputDecoration(
                        labelText: 'Delimiter',
                        errorText: state.delimiterError,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => bloc.add(DelimiterChanged(v)),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Numbers',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      key: const Key('numbers-field'),
                      minLines: 2,
                      maxLines: 4,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        labelText: 'Numbers',
                        hintText: r'Examples: 1,2,3   or   1\n2,3',
                        errorText: state.numbersError,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => bloc.add(NumbersChanged(v)),
                    ),
                  ],

                  if (state.mode == InputMode.raw) ...[
                    Text(
                      'Raw input string',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      key: const Key('raw-field'),
                      minLines: 2,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: r'Raw string',
                        errorText: state.rawError,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => bloc.add(RawInputChanged(v)),
                    ),
                  ],

                  const SizedBox(height: 20),
                  Text(
                    'Preview:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      state.preview.isEmpty
                          ? ''
                          : state.preview.replaceAll('\n', r'\n'),
                      key: const Key('preview-text'),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.icon(
                        key: const Key('submit-button'),
                        onPressed:
                            state.isSubmitting
                                ? null
                                : () => bloc.add(const Submitted()),
                        icon: const Icon(Icons.calculate),
                        label: Text(
                          state.isSubmitting ? 'Calculating...' : 'Calculate',
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (state.result != null)
                        Text(
                          'Sum: ${state.result}',
                          key: const Key('result-text'),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (state.submitError != null)
                    Text(
                      state.submitError!,
                      key: const Key('error-text'),
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
