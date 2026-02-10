# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

{{project_name.titleCase()}} is a Flutter application following **Clean Architecture** principles with clear separation between domain, data, and presentation layers.

## Architecture

The project follows Clean Architecture with three main layers:

1. **Domain Layer** (`lib/features/[feature]/domain/`)
   - Entities: Business objects
   - Repositories: Abstract contracts
   - Use Cases: Single business actions

2. **Data Layer** (`lib/features/[feature]/data/`)
   - Models: JSON serializable data classes
   - Data Sources: Remote (API) and Local (Cache/DB)
   - Repository Implementations

3. **Presentation Layer** (`lib/features/[feature]/presentation/`)
   - BLoC: State management
   - Pages: Full screen widgets
   - Widgets: Reusable components

## Technology Stack

- **State Management**: flutter_bloc, equatable
- **Dependency Injection**: get_it, injectable
- **Routing**: go_router
- **Networking**: dio, connectivity_plus
- **Storage**: shared_preferences, hive{{#include_localization}}
- **Localization**: easy_localization (English & Arabic){{/include_localization}}{{#include_image_picker}}
- **Image Handling**: cached_network_image, image_picker{{/include_image_picker}}
- **Functional Programming**: dartz
- **Logging**: logging package

## Development Commands

### Setup and Dependencies

```bash
# Install dependencies
flutter pub get

# Run code generation (injectable, hive)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Running the Application

```bash
# Run with default (dev) environment
flutter run

# Run with dev environment and flavor explicitly
flutter run --flavor dev -t lib/main_dev.dart

# Run with production environment and flavor
flutter run --flavor prod -t lib/main_prod.dart

# Run with mock mode (for testing without backend)
flutter run --flavor dev -t lib/main_mock.dart
```

### Code Generation

Always run code generation after:
- Adding new injectable dependencies
- Creating new Hive models
- Modifying @injectable or @HiveType annotations

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Code Quality

```bash
# Run static analysis
flutter analyze

# Format code
dart format .
```

### Building

```bash
# Android Dev Build
flutter build apk --flavor dev -t lib/main_dev.dart

# Android Production Build
flutter build apk --flavor prod -t lib/main_prod.dart

# Clean before building
flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
```

## App Naming Configuration

The app display name is automatically configured to show in Title Case with spaces on device home screens:
- **Android**: Configured in `android/app/src/main/AndroidManifest.xml` with `android:label="{{project_name.titleCase()}}"`
- **iOS**: Configured in `ios/Runner/Info.plist` with `CFBundleDisplayName` and `CFBundleName`

Example: If project name is `my_awesome_app`, the app displays as "My Awesome App" on devices.

## Environment Configuration

Environments are configured in `lib/config/env_config.dart`:

- **Development**: `{{dev_api_url}}`
- **Production**: `{{prod_api_url}}`
- **Mock**: Uses mock data sources (no backend required)

## User Preferences

- Prefer reusable widgets over widget methods
- Prefer stateless widgets with BLoC state management
- Use shimmer for loading screens
- Use AppColors class and theme color scheme
- Create separate files for each reusable widget
{{#include_localization}}
## Localization

Translations are stored in `assets/translations/`:
- `en.json` - English translations
- `ar.json` - Arabic translations

Use in code: `'key'.tr()` or `context.tr('key')`
{{/include_localization}}
## Core Services

### LoggerService
```dart
final logger = LoggerService();
logger.info('Information message');
logger.error('Error message', error, stackTrace);
```

### ApiClient
```dart
final apiClient = getIt<ApiClient>();
final response = await apiClient.get('/endpoint');
```

### LocalStorageService
```dart
final storage = getIt<LocalStorageService>();
await storage.setString('key', 'value');
```

### HiveService
```dart
final hive = getIt<HiveService>();
await hive.put('boxName', 'key', data);
```

## Adding a New Feature

1. Create feature directory structure following Clean Architecture
2. Define domain entities and repository contracts
3. Create use cases
4. Implement data layer
5. Create BLoC
6. Build UI
7. Register dependencies in `lib/config/injection.dart`
8. Add routes in `lib/config/router.dart`
9. Run code generation
{{#include_localization}}10. Add translations to `assets/translations/`{{/include_localization}}

## Best Practices

1. **Always use dependency injection**
2. **Follow Clean Architecture**
3. **Use Either for error handling**
4. **Check connectivity before API calls**{{#include_localization}}
5. **Localize all strings**{{/include_localization}}
6. **Use const constructors**
7. **Implement Equatable for BLoC**
8. **Write testable code**
