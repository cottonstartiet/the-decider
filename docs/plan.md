# The Decider — Implementation Plan

## Problem
Build new decider tool screens for the Flutter "The Decider" app and document future tool ideas.

## Approach
Follow the existing coin flip screen pattern (StatefulWidget + SingleTickerProviderStateMixin + animations) to create each new tool, wire them into the home screen grid, and create a docs file with future ideas.

## Completed Tasks

### 1. Random Number Generator Screen
- File: `lib/screens/random_number_screen.dart`
- Picks a random number between 1–10
- Scale/bounce animation on a sage-green circle
- Tap to generate, result revealed with AnimatedOpacity

### 2. Random Color Picker Screen
- File: `lib/screens/color_picker_screen.dart`
- Picks from 4 colors: red, green, yellow, blue
- Spinning 4-quadrant color wheel with custom `_QuadrantClipper`
- Center dot shows selected color after spin

### 3. Pass or Take Decider Screen
- File: `lib/screens/pass_take_screen.dart`
- Binary pass/take decision
- Horizontal slide animation with icons
- Rounded-rectangle card shape

### 4. Home Screen Update
- File: `lib/screens/home_screen.dart`
- Added imports for all 3 new screens
- Added 3 new `_ToolItem` entries with navigation

### 5. Future Tools Documentation
- File: `docs/tools.md` (repo root)
- 10 future tool ideas: dice roller, magic 8-ball, spin the bottle, yes/no oracle, priority picker, rock-paper-scissors, slot machine, compass of fate, double or nothing, mood picker

## Validation
- `flutter analyze` — no issues found
- `flutter test` — all tests passed

## Notes
- All screens use `ZenTheme` color constants (no raw color values)
- Animations use `AnimationController` with `SingleTickerProviderStateMixin`
- Navigation via `MaterialPageRoute` push from `HomeScreen`
- Uses `Color.withValues(alpha:)` instead of deprecated `withOpacity()`
