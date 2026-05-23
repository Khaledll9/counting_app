<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.4+-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.4+-0175C2?logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/State_Management-flutter_bloc_Cubit-0288D1" alt="State Management"/>
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License"/>
  <img src="https://img.shields.io/badge/Platform-Android_|_iOS_|_Web_|_Desktop-lightgrey" alt="Platform"/>
</p>

<h1 align="center">Points Counter &mdash; Real-Time Team Scoreboard</h1>
<p align="center"><em>A declarative Flutter application demonstrating reactive state management via the BLoC (Cubit) pattern, purpose-built for live head-to-head scoring scenarios.</em></p>

---

## 1. The Problem &amp; The Solution

**Problem.** In competitive environments such as debate tournaments, quiz bowls, or LAN game sessions, tracking scores for two opposing teams typically relies on manual tallies, whiteboards, or general-purpose calculator apps. These approaches lack persistence, introduce human arithmetic errors, and provide no visual separation between competing entities. The result is a low-trust, high-friction scoring experience.

**Solution.** This application delivers a minimal, focused, two-team (A/B) points counter that decouples score state from UI rendering through the BLoC (Cubit) architectural pattern. Increments of 1, 2, or 3 points per button press, combined with a single-tap reset, eliminate arithmetic overhead and provide immediate visual feedback via reactive UI updates. The architecture is deliberately scoped to solve one problem well: real-time, zero-latency score display for exactly two competing teams.

---

## 2. Architectural Patterns &amp; Software Engineering Principles

### 2.1 BLoC (Cubit) &mdash; Business Logic Component Pattern

The project adopts **flutter_bloc Cubit** — a lightweight subset of the full BLoC pattern — to enforce a unidirectional data flow and a clean separation between business logic and presentation:

```
User Action → Cubit Method → State Mutation → emit(newState) → UI Rebuild
```

- **CounterCubit** (`lib/cubit/counter_cubit.dart`) owns all mutable score state (`teamAPoints`, `teamBPoints`) and exposes exactly two commands: `teamIncrement(team, buttomNumber)` and `setPoints()`.
- **State classes** (`lib/cubit/counter_state.dart`) serve as discriminated union markers (`CounterState`, `CounterAIncrementState`, `CounterBIncrementState`) that trigger type-aware UI reactions via `BlocConsumer`.
- **UI layer** (`lib/main.dart`) is a pure function of state — it reads live point values through `BlocProvider.of<CounterCubit>(context).teamAPoints` and rebuilds only when the Cubit emits a new state.

This pattern guarantees that no business logic leaks into widget code and that the entire application state is predictable, testable, and auditable.

### 2.2 Separation of Concerns &amp; Modularity

| Layer | Responsibility | File(s) |
|-------|---------------|---------|
| **Presentation** | Widget tree, layout, styling | `lib/main.dart` |
| **State (Cubit)** | Command handling, score mutation, state emission | `lib/cubit/counter_cubit.dart` |
| **State (Model)** | Type-safe state markers | `lib/cubit/counter_state.dart` |

The widget layer never mutates state directly — it calls Cubit methods, and the Cubit owns the decision of what state to emit and when.

### 2.3 Reactive UI via BlocConsumer

`HomePage` uses `BlocConsumer<CounterCubit, CounterState>`, which provides:
- **builder** — a pure `(context, state) → Widget` function that renders the scoreboard on every state emission.
- **listener** — a side-effect callback (currently a no-op, reserved for future concerns such as haptic feedback or sound effects).

This dual-channel design enforces the principle that side effects (navigation, toasts, sounds) should never originate from the `builder` callback.

### 2.4 Dependency Injection via BlocProvider

`CounterCubit` is registered at the app root via `BlocProvider` — Flutter's InheritedWidget-style DI mechanism provided by flutter_bloc. Every descendant widget can access the singleton Cubit instance without manual prop drilling or global singletons:

```dart
BlocProvider(
  create: (context) => CounterCubit(CounterState()),
  child: const MaterialApp(...),
)
```

---

## 3. Key Engineering Features &amp; Technical Depth

- **🔄 Reactive State Synchronization.** Score changes propagate from Cubit → emitted state → UI rebuild in a single synchronous frame. No `setState()` calls, no manual `notifyListeners()` — the framework handles differential rebuilds automatically.
- **⚡ Optimized Rebuild Scope.** `BlocConsumer` only rebuilds the subtree returned by its `builder`. Despite the entire scoreboard living in one widget, the framework's internal diffing (`Element.rebuild`) ensures only changed `Text` widgets repaint.
- **🧩 Discriminated Union States.** Three distinct state classes (`CounterState`, `CounterAIncrementState`, `CounterBIncrementState`) enable future expansion to per-team animations, sound effects, or analytics without restructuring the state hierarchy.
- **📱 Cross-Platform Compatibility.** Built with Flutter's platform-agnostic widget set, the application compiles to Android, iOS, Web, Linux, macOS, and Windows from a single codebase.
- **✅ Static Analysis.** `flutter_lints` (via `analysis_options.yaml`) enforces Dart's recommended lint rules at compile time, catching anti-patterns before runtime.

---

## 4. Technology Stack &amp; Dependencies

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| **Language** | Dart | `>=3.4.3 <4.0.0` | Application logic & type system |
| **Framework** | Flutter | 3.4+ | UI toolkit & cross-platform rendering |
| **State Management** | flutter_bloc | `^8.1.6` | Cubit pattern — business logic & state emission |
| **Linting** | flutter_lints | `^3.0.0` | Static analysis rule set |
| **Icons** | cupertino_icons | `^1.0.6` | iOS-style iconography |
| **Testing** | flutter_test | SDK | Widget & unit test framework |

---

## 5. Folder Structure

The project follows a layer-first directory layout within `lib/`, isolating Cubit (business logic) from widget (presentation) code:

```
counting_app/
├── android/                          # Android platform host
├── ios/                              # iOS platform host
├── lib/                              # Application source
│   ├── cubit/
│   │   ├── counter_cubit.dart        # Cubit — state mutations & commands
│   │   └── counter_state.dart        # State model — type-safe markers
│   └── main.dart                     # Entry point, DI setup, widget tree
├── linux/                            # Linux platform host
├── macos/                            # macOS platform host
├── test/
│   └── widget_test.dart              # Widget smoke test (WIP)
├── web/                              # Web platform host
├── windows/                          # Windows platform host
├── analysis_options.yaml             # Lint configuration
├── pubspec.yaml                      # Dependency manifest
└── README.md                         # This file
```

The structure is deliberately flat at the `lib/` top level, reflecting the current scope. As the feature surface grows, the following expansion path is recommended (see §7):

```
lib/
├── core/               # Shared utilities, constants, theme
├── cubit/              # Business logic (existing)
├── model/              # Data classes, serialization
├── repository/         # Data access abstraction
├── service/            # External API / Firebase integration
└── view/               # Page-level widgets (moved from main.dart)
```

---

## 6. Installation &amp; Configuration Guide

### Prerequisites

- **Flutter SDK** `>=3.4.3` ([install guide](https://docs.flutter.dev/get-started/install))
- **Dart SDK** (bundled with Flutter)
- A code editor (VS Code, Android Studio, or IntelliJ)
- A physical device or emulator for mobile testing

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/<your-org>/counting_app.git
cd counting_app

# 2. Install dependencies
flutter pub get

# 3. Verify the project compiles
flutter analyze

# 4. Run the test suite
flutter test

# 5. Launch on a connected device / emulator
flutter run
```

> **Note:** This application has no external service dependencies (no Firebase, no REST API, no local database). It runs fully offline with zero configuration beyond <code>flutter pub get</code>. The `flutter analyze` step should produce zero errors.

---

## 7. Future Scalability Roadmap

The following architectural enhancements are designed to preserve the existing codebase's integrity while scaling it into a production-grade application:

### Short-Term (Next 3 Months)

| Enhancement | Rationale | Engineering Approach |
|------------|-----------|---------------------|
| **Typed state with data payloads** | Current state classes are empty markers; scores live on Cubit mutable fields. This breaks the BLoC convention of immutable, self-describing states. | Refactor state to `CounterState({int teamAPoints, int teamBPoints})` and remove `teamAPoints`/`teamBPoints` from the Cubit. |
| **Fix widget test** | `test/widget_test.dart` references `Icons.add`, which does not exist in the UI — the test fails. | Rewrite test to locate `ElevatedButton` by text (`'Add 1 point'`) and verify score text updates. |
| **Add unit tests for Cubit** | Zero unit tests currently cover `CounterCubit`. | Use `bloc_test` package to verify `teamIncrement` and `setPoints` produce correct state sequences. |
| **Repository layer** | Direct Cubit mutation should be mediated by a repository for testability. | Introduce `ScoreRepository` interface with `InMemoryScoreRepository` implementation; inject via Cubit constructor. |

### Mid-Term (3–12 Months)

| Enhancement | Rationale |
|------------|-----------|
| **Persistent storage (Hive / Isar)** | Scores reset on app restart; a lightweight embedded database would persist game state across sessions. |
| **Per-team undo/redo stack** | Accidental taps require rollback. A command-pattern undo stack (max 10 operations per team) would resolve this. |
| **Game timer & auto-pause** | Add a countdown timer per round with automatic score freeze on timeout. |
| **Custom point values** | Replace fixed +1/+2/+3 buttons with a numeric input field for arbitrary increment values. |
| **Dark mode & theming** | Expose a `ThemeMode` toggle via a `SettingsCubit` — decoupled from scoring logic. |

### Long-Term (12+ Months)

| Enhancement | Architectural Impact |
|------------|---------------------|
| **Firebase Authentication + Cloud Firestore** | Introduce `auth/` and `service/` layers. Multi-device sync requires converting `ScoreRepository` from in-memory to Firestore-backed, with real-time listeners via `Stream<QuerySnapshot>`. |
| **Match history with replay** | Each `teamIncrement` becomes an immutable `ScoreEvent` stored in a list; the UI can replay the match step-by-step. |
| **Multi-match tournament bracket** | The single Cubit becomes a `MatchCubit` within a `TournamentCubit` that manages a bracket tree. Requires the repository layer to support batch queries. |
| **Internationalization (l10n)** | Extract all user-facing strings into ARB files and wrap the app in `flutter_localizations`. |

---

## Known Technical Debt

The following items are documented as intentional trade-offs or in-progress work:

| Item | Status | Notes |
|------|--------|-------|
| Empty state marker classes | ⚠️ _Acknowledged_ | State classes carry no data; all score state lives on Cubit fields. This is a deviation from canonical BLoC and is prioritized for refactoring. |
| Misspelled parameter `buttomNumber` | ⚠️ _Acknowledged_ | Typo in `CounterCubit.teamIncrement()` — tracked for correction in the next refactor cycle. |
| Non-standard reset method name `setPoints()` | ⚠️ _Acknowledged_ | Convention would be `reset()`. Renaming is scheduled alongside the state-refactor sprint. |
| Broken widget test (`test/widget_test.dart`) | ❌ _Known failing_ | References `Icons.add` not present in the UI. Will be rewritten as part of short-term roadmap. |

---

<p align="center">
  <sub>Built with Flutter &middot; Maintained with clean architecture principles</sub>
  <br>
  <sub>Erasmus Mundus &amp; Chevening Applicant &mdash; Software Engineering (MSc)</sub>
</p>