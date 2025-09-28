# String Calculator App

A Flutter app where we explore the classic String Calculator kata..

## What this project does

- Lets you add numbers by either composing an input (delimiter + numbers) or by pasting the raw string directly.
- Shows a live preview so you can see the exact payload that goes to the calculator before you hit Calculate.
- Surfaces validation errors (delimiter format, number format, etc.) before the calculation runs.

## Getting set up

1. Fetch packages: `flutter pub get`
2. Spin up the app: `flutter run`

## Running the tests

I try to keep a safety net around every layer. Run them all with:

```bash
flutter test
```

You can also target a specific folder (for example `flutter test test/presentation`).

## Project layout

- `lib/core` – input validation helpers.
- `lib/domain` – entities, ports, and the sum use case.
- `lib/infrastructure` – adapter that wraps the actual kata package.
- `lib/presentation` – Flutter widgets + Bloc state management for the UI.
- `package/string_calculator` – the kata implementation that powers the adapter.
- `test` – unit, bloc, and widget tests covering the app and the kata package.

## Notes

- The project uses `flutter_bloc`, `equatable`, and `mocktail` to keep state predictable and tests friendly.
- When editing the package under `package/string_calculator`, remember to re-run `flutter test` at the root to make sure everything still plays nicely together.
