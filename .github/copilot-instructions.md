# Copilot Instructions

## Project Overview

"The Decider" is a Flutter decision-making app with a zen/minimalist aesthetic. The Flutter project lives in the `flutter_decider/` subdirectory — all Flutter commands must be run from there.

## Build & Run

```bash
cd flutter_decider

# Install dependencies
flutter pub get

# Run the app
flutter run

# Analyze (lint)
flutter analyze

# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart
```

## Architecture

- **`lib/main.dart`** — App entry point. Creates `DeciderApp` which applies `ZenTheme` and routes to `HomeScreen`.
- **`lib/screens/`** — Each decision tool gets its own screen. `HomeScreen` displays a grid of tool cards; tapping one navigates to that tool's screen via `MaterialPageRoute`.
- **`lib/theme/zen_theme.dart`** — Single centralized theme (`ZenTheme`) with a named color palette: `sage`, `deepSage`, `sand`, `warmBeige`, `stone`, `charcoal`, `softWhite`, `accent`. All styling should use these colors and the `ZenTheme.theme` ThemeData.

## Adding a New Decision Tool

1. Create a new screen in `lib/screens/` (e.g., `dice_roll_screen.dart`).
2. Add a `_ToolItem` entry in `HomeScreen`'s `tools` list with a title, subtitle, icon, and `onTap` that navigates to the new screen.
3. Disabled/placeholder tools use `onTap: null`, which renders the card at reduced opacity.

## Conventions

- **State management**: `StatefulWidget` with `SingleTickerProviderStateMixin` for animations — no external state management packages.
- **Theming**: Never use raw color values in screens. Reference `ZenTheme` constants (e.g., `ZenTheme.deepSage`) or pull from `Theme.of(context)`.
- **Typography**: Use `Theme.of(context).textTheme` styles (`headlineLarge`, `bodyMedium`, etc.) rather than inline `TextStyle` definitions.
- **Widget visibility**: Screen-internal helper widgets and data classes are file-private (prefixed with `_`).
- **Const constructors**: Use `const` constructors wherever possible.
- **Linting**: Uses `flutter_lints` (configured in `analysis_options.yaml`). Run `flutter analyze` to check.
