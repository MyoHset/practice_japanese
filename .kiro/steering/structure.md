# Project Structure

```
lib/
├── main.dart          # App entry point with DI setup
├── app.dart           # Root JlptApp widget
│
├── core/              # Shared infrastructure (cross-cutting concerns)
│   ├── constants/     # App-wide constants (strings, colors, dimensions)
│   ├── database/      # Drift database setup and migrations
│   ├── extensions/    # Dart extension methods
│   ├── providers/     # Global Riverpod providers
│   ├── router/        # GoRouter configuration
│   ├── theme/         # AppTheme and styling
│   └── widgets/       # Reusable UI components
│
└── features/          # Feature-based modules (vertical slice architecture)
    ├── home/          # Home screen
    ├── level/         # JLPT level selection
    ├── library/       # Vocabulary/grammar library
    ├── past_exam/     # Past exam practice
    └── splash/        # Splash screen
```

## Architecture Patterns

**State Management:** Riverpod with ProviderScope in main.dart

**Navigation:** GoRouter with nested routes

**Database:** Drift (SQLite) - tables defined in `core/database/`

**DI:** Riverpod overrides in `core/providers/`

**Theme:** AppTheme class in `core/theme/`

## File Naming Conventions
- Screen widgets: `feature_name_screen.dart`
- Controllers: `feature_name_controller.dart`
- Providers: `feature_name_provider.dart`
- Models: `feature_name.dart`

## Assets
- Data files: `assets/data/`
- Images: `assets/images/`