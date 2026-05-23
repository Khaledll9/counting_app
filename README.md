<div align="center">
  <br/>
  <img src="https://img.shields.io/badge/Flutter-3.4%2B-02569B?style=flat&logo=flutter&logoColor=white" alt="Flutter 3.4+"/>
  <img src="https://img.shields.io/badge/Dart-3.4%2B-0175C2?style=flat&logo=dart&logoColor=white" alt="Dart 3.4+"/>
  <img src="https://img.shields.io/badge/State_Management-BLoC_Cubit-0288D1?style=flat" alt="BLoC Cubit"/>
  <img src="https://img.shields.io/badge/Platform-Android_|_iOS_|_Web_|_Desktop-lightgrey?style=flat" alt="Platforms"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat" alt="MIT License"/>
  <img src="https://img.shields.io/badge/build-passing-brightgreen?style=flat" alt="Build Status"/>

  <br/><br/>

  <!-- Application Banner Placeholder -->
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="">
    <img alt="Points Counter App Banner" src="" width="600">
  </picture>

  <h1>Points Counter</h1>
  <p><strong>Real-time head-to-head scoreboard for competitive environments.</strong><br/>
  A declarative Flutter application that leverages the BLoC (Cubit) pattern to deliver zero-latency, reactive scoring for two competing teams — no backend, no boilerplate, just pure local state management.</p>
</div>

---

## About The Project

In competitive settings — debate tournaments, quiz bowls, LAN parties, or board game nights — tracking scores for two opposing teams is an exercise fraught with friction. Whiteboards smudge, calculators mis-tap, and general-purpose apps fail to isolate the two competing contexts. The result: broken focus, disputed scores, and a degraded competitive experience.

This application solves exactly one problem, and solves it well. It provides a **purpose-built, two-team (A/B) points counter** with tactile +1/+2/+3 increments, a single-tap reset, and reactive UI updates that reflect state changes in the same frame they occur. Built on flutter_bloc's Cubit pattern, it enforces a clean separation between business logic and presentation, ensuring the scoreboard is always consistent, predictable, and testable.

## Tech Stack & Core Ecosystem

| Technology | Version | Role in the Project |
|---|---|---|
| **Dart** | `>=3.4.3 <4.0.0` | Strongly-typed application logic with sound null safety |
| **Flutter** | SDK 3.4+ | Cross-platform UI rendering engine — single codebase, six targets |
| **flutter_bloc** | `^8.1.6` | Cubit-based state management — unidirectional data flow, no `setState()` |
| **cupertino_icons** | `^1.0.6` | iOS-style iconography for platform-adaptive aesthetics |
| **flutter_lints** | `^3.0.0` | Compile-time lint enforcement via Dart's recommended rule set |
| **flutter_test** | SDK | Widget and unit testing framework for regression safety |

## Key Architecture

The project adopts a **layer-first, feature-minimal** architecture. Data flows unidirectionally through a single Cubit, with zero intermediate layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  lib/main.dart                                              │
│                                                             │
│  ┌──────────────────┐    ┌──────────────────────────────┐   │
│  │  BlocProvider     │───▶│  HomePage (BlocConsumer)     │   │
│  │  (DI root)        │    │  ┌────────────────────────┐ │   │
│  └──────────────────┘    │  │  builder: (ctx, state)  │ │   │
│                          │  │    → read cubit fields   │ │   │
│                          │  │    → render scoreboard   │ │   │
│                          │  ├────────────────────────┤ │   │
│                          │  │  listener: (ctx, state) │ │   │
│                          │  │    → side effects (noop)│ │   │
│                          │  └────────────────────────┘ │   │
│                          └──────────────────────────────┘   │
└────────────────────┬────────────────────────────────────────┘
                     │ calls teamIncrement() / setPoints()
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   BUSINESS LOGIC LAYER                      │
│  lib/cubit/counter_cubit.dart                                │
│                                                             │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  CounterCubit extends Cubit<CounterState>              │ │
│  │                                                        │ │
│  │  Fields                                                │ │
│  │  ├── teamAPoints : int                                 │ │
│  │  └── teamBPoints : int                                 │ │
│  │                                                        │ │
│  │  Methods                                               │ │
│  │  ├── teamIncrement(team, buttomNumber) → emit(state)  │ │
│  │  └── setPoints() → emit(CounterState())               │ │
│  └────────────────────────────────────────────────────────┘ │
└────────────────────┬────────────────────────────────────────┘
                     │ emit()
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    STATE (MODEL) LAYER                      │
│  lib/cubit/counter_state.dart                                │
│                                                             │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  CounterState            (base — empty marker)         │ │
│  │  ├── CounterAIncrementState  (Team A scored)           │ │
│  │  └── CounterBIncrementState  (Team B scored)           │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

**Unidirectional flow**: A user taps a button → the widget calls a Cubit method → the Cubit mutates its internal fields and emits a discriminant state → `BlocConsumer` rebuilds the affected subtree. No presentation logic leaks into the Cubit; no business logic leaks into the widget.

## Key Features

### Reactive State Management
- **BLoC Cubit isolation** — All score state lives in `CounterCubit`; widgets are pure consumers via `BlocProvider.of<CounterCubit>(context)`
- **Discriminated union states** — Three state classes (`CounterState`, `CounterAIncrementState`, `CounterBIncrementState`) enable per-team side-effect routing without conditional logic
- **Synchronous UI diffusion** — State mutations propagate to the widget tree within a single microtask frame; no manual `setState()` or `notifyListeners()`

### Purpose-Built Scoring
- **Preset increment buttons** — Dedicated +1, +2, +3 for each team eliminate arithmetic overhead during fast-paced events
- **One-tap reset** — Clears both team scores simultaneously, restoring the board to a neutral state
- **Clear visual hierarchy** — Large, typography-first score display (150px text) with distinct team columns separated by a vertical divider

### Cross-Platform & Quality
- **Six-platform targeting** — Android, iOS, Web, Linux, macOS, and Windows from a single Dart codebase
- **Static analysis enforcement** — `flutter_lints` 3.0 catches anti-patterns and style violations at compile time
- **Zero runtime dependencies** — No cloud services, no databases, no API keys required. The app runs fully offline with `flutter pub get` as the only setup step

## Getting Started & Local Setup

### Prerequisites

| Requirement | Version | Installation |
|---|---|---|
| Flutter SDK | `>=3.4.3` | [Install Flutter](https://docs.flutter.dev/get-started/install) |
| Dart SDK | (bundled with Flutter) | — |
| Android Studio / Xcode | Latest stable | For mobile emulators |
| Git | Latest | [Install Git](https://git-scm.com/) |

### Setup Steps

```bash
# 1. Clone the repository
git clone https://github.com/<your-org>/counting_app.git
cd counting_app

# 2. Fetch dependencies
flutter pub get

# 3. Run static analysis (should produce zero errors)
flutter analyze

# 4. Run the test suite
flutter test

# 5. Launch the application on a connected device or emulator
flutter run
```

> No environment variables, API keys, or configuration files are needed. The application is fully self-contained and ready to run immediately after `flutter pub get`.

## Screenshots & UI Showcase

```
┌───────────────────────┬───────────────────────┐
│                       │                       │
│   [Mockup Placeholder │   [Mockup Placeholder │
│    — Light Mode]      │    — Dark Mode]       │
│                       │                       │
│   ┌─────────────┐     │   ┌─────────────┐     │
│   │  Team A     │     │   │  Team A     │     │
│   │   12        │     │   │   12        │     │
│   │ [+1][+2][+3]│     │   │ [+1][+2][+3]│     │
│   └─────────────┘     │   └─────────────┘     │
│                       │                       │
└───────────────────────┴───────────────────────┘
┌───────────────────────┬───────────────────────┐
│                       │                       │
│   [Mockup Placeholder │   [Mockup Placeholder │
│    — Android]         │    — iOS]             │
│                       │                       │
└───────────────────────┴───────────────────────┘
```

> Replace the placeholder areas above with actual screenshots from `screenshots/` once captured.

## Contact & Licensing

<p align="center">
  <strong>Project maintainer:</strong>
  <a href="https://github.com/<your-username>">GitHub</a> ·
  <a href="https://linkedin.com/in/<your-profile>">LinkedIn</a> ·
  <a href="mailto:<your-email>">Email</a>
</p>

<p align="center">
  Distributed under the <strong>MIT License</strong>. See <a href="LICENSE">LICENSE</a> for more information.
</p>

<p align="center">
  <sub>Built with Flutter &middot; Designed with clean architecture principles</sub>
</p>
