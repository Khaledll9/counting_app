# counting_app

Flutter points-counter app for two teams (A/B).

## Commands

- `flutter analyze` — static analysis
- `flutter test` — run tests
- `flutter run` — launch on device/emulator

## Architecture

- **State management**: `flutter_bloc` Cubit pattern (`lib/cubit/`)
- **Entry point**: `lib/main.dart` — `PointerCounterState` widget wraps app in `BlocProvider<CounterCubit>`
- **Cubit** (`lib/cubit/counter_cubit.dart`): `teamAPoints` / `teamBPoints` stored as mutable Cubit fields (state classes are empty markers — not the standard pattern)
- **State classes** (`lib/cubit/counter_state.dart`): `CounterState`, `CounterAIncrementState`, `CounterBIncrementState`
- **UI pattern**: `HomePage` uses `BlocConsumer<CounterCubit, CounterState>` (builder renders scoreboard, listener is a no-op)

## Notable quirks

- `teamIncrement` parameter is misspelled `buttomNumber` (not `buttonNumber`) — declared in cubit, used in UI
- The state objects carry no data; actual points live in Cubit fields and are read via `BlocProvider.of<CounterCubit>(context)`
- Reset calls `setPoints()` (not a standard name like `reset`)
- Widget test (`test/widget_test.dart`) references `Icons.add` which does not exist in the UI — test is broken
- Multi-platform: Android, iOS, Linux, macOS, Web, Windows
- SDK: `>=3.4.3 <4.0.0`