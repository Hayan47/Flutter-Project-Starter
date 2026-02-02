# {{project_name.titleCase()}}

{{project_description}}

## Features

- ✅ Clean Architecture with clear separation of concerns
- ✅ BLoC for state management
- ✅ Dependency Injection with get_it and injectable
- ✅ Multi-environment support (Dev, Prod, Mock)
- ✅ go_router for navigation{{#include_localization}}
- ✅ Localization support (English & Arabic){{/include_localization}}
- ✅ Comprehensive error handling
- ✅ Network layer with Dio
- ✅ Local storage (SharedPreferences & Hive)
- ✅ Connectivity monitoring{{#include_image_picker}}
- ✅ Image picker and file handling{{/include_image_picker}}{{#include_maps}}
- ✅ Maps and location services{{/include_maps}}

## Getting Started

### Prerequisites

- Flutter SDK ^3.7.0
- Dart SDK ^3.7.0

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd {{project_name.snakeCase()}}
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the App

#### Development Environment
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

#### Production Environment
```bash
flutter run --flavor prod -t lib/main_prod.dart
```

#### Mock Environment
```bash
flutter run --flavor dev -t lib/main_mock.dart
```

### Building the App

#### Android Dev Build
```bash
flutter build apk --flavor dev -t lib/main_dev.dart
flutter build appbundle --flavor dev -t lib/main_dev.dart
```

#### Android Production Build
```bash
flutter build apk --flavor prod -t lib/main_prod.dart
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

## Project Structure

```
lib/
├── config/              # Configuration (DI, routing, environment)
├── core/               # Core utilities (network, storage, services)
├── features/           # Feature modules (Clean Architecture)
├── shared/             # Shared resources (widgets, theme, constants)
├── app.dart           # App widget
├── main.dart          # Entry point (default to dev)
├── main_dev.dart      # Development entry point
├── main_prod.dart     # Production entry point
└── main_mock.dart     # Mock entry point
```

## Code Generation

Always run code generation after:
- Adding new injectable dependencies
- Creating new Hive models
- Modifying @injectable or @HiveType annotations

```bash
# Generate once
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Development Commands

```bash
# Run static analysis
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## Environment Configuration

Update API base URLs in `lib/config/env_config.dart`:

- **Development**: `{{dev_api_url}}`
- **Production**: `{{prod_api_url}}`
- **Mock**: Uses mock data sources (no backend required)

## Adding a New Feature

1. Create feature directory structure following Clean Architecture:
```
lib/features/feature_name/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

2. Define domain entities and repository contracts
3. Create use cases
4. Implement data layer (models, datasources, repositories)
5. Create BLoC (events, states, bloc)
6. Build UI (pages and widgets)
7. Register dependencies in `lib/config/injection.dart`
8. Add routes in `lib/config/router.dart` and `lib/config/routes.dart`
9. Run code generation

## Best Practices

1. Always use dependency injection
2. Follow Clean Architecture principles
3. Use Either for error handling
4. Check connectivity before making API calls{{#include_localization}}
5. Localize all user-facing strings{{/include_localization}}
6. Use const constructors for better performance
7. Implement Equatable for BLoC state comparison
8. Write testable code following SOLID principles

## License

This project is licensed under the MIT License - see the LICENSE file for details.
