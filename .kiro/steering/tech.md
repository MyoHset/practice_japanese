# Tech Stack

**Framework:** Flutter 3.5+ (Dart SDK ^3.5.0)

## Dependencies

**State Management:** `flutter_riverpod` ^2.6.1

**Navigation:** `go_router` ^14.6.2

**Local Database:** `drift` ^2.22.1 + `drift_flutter` ^2.2.4 + `sqlite3_flutter_libs`

**Settings:** `shared_preferences` ^2.3.3

## Dev Dependencies
- `flutter_test` (testing)
- `flutter_lints` ^6.0.0 (linting)
- `drift_dev` ^2.22.1 (database code generation)
- `build_runner` ^2.4.13 (code generation)

## Common Commands

```bash
# Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# Run in debug mode
flutter run

# Build release APK
flutter build apk --release

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Code Style Rules
- Always use package imports (`always_use_package_imports`)
- Prefer const constructors and declarations
- Use final locals and fields
- Avoid print statements (use debugPrint or logging)
- Sort child properties last in widgets
- Use trailing commas for multi-line parameters