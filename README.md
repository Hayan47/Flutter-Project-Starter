# Flutter Clean Architecture Mason Brick

A comprehensive Mason brick for generating Flutter projects with Clean Architecture, BLoC state management, and multi-environment support.

## Features

- ✅ **Clean Architecture** - Clear separation of domain, data, and presentation layers
- ✅ **BLoC Pattern** - State management with flutter_bloc
- ✅ **Dependency Injection** - Using get_it and injectable
- ✅ **Multi-Environment** - Dev, Prod, and Mock environments
- ✅ **Routing** - go_router for navigation
- ✅ **Localization** - Optional easy_localization support (English & Arabic)
- ✅ **Network Layer** - Dio with interceptors and error handling
- ✅ **Local Storage** - SharedPreferences and Hive
- ✅ **Connectivity** - Network status monitoring
- ✅ **Image Handling** - Optional image picker support
- ✅ **Maps** - Optional Google Maps and location services
- ✅ **Comprehensive Theme** - Material 3 with custom colors and fonts
- ✅ **Error Handling** - Using dartz Either pattern

## Installation

### Prerequisites

- Mason CLI installed: `dart pub global activate mason_cli`
- Flutter SDK ^3.7.0

### Install the Brick

```bash
# Install from path
mason add flutter_clean_architecture --path /path/to/flutter_clean_architecture_brick

# Or install from git (if published)
# mason add flutter_clean_architecture --git-url <your-repo-url>
```

## Usage

### Generate a New Project

```bash
mason make flutter_clean_architecture
```

You'll be prompted for:

1. **Project Name** - In snake_case (e.g., `my_awesome_app`)
2. **Project Description** - Brief description
3. **Organization** - Reverse domain notation (e.g., `com.example`)
4. **Dev API URL** - Development API base URL
5. **Prod API URL** - Production API base URL
6. **Include Localization** - Whether to include easy_localization
7. **Include Maps** - Whether to include Google Maps support
8. **Include Image Picker** - Whether to include image picker
9. **Primary Color** - Hex code without # (e.g., `1976D2`)
10. **Secondary Color** - Hex code without # (e.g., `424242`)

### Example

```bash
$ mason make flutter_clean_architecture
? What is your project name? my_app
? Enter project description A new Flutter project with Clean Architecture
? What is your organization? com.mycompany
? Enter development API URL https://dev-api.mycompany.com
? Enter production API URL https://api.mycompany.com
? Include localization support? Yes
? Include maps and location features? No
? Include image picker and file handling? Yes
? Enter primary color hex (without #) 2196F3
? Enter secondary color hex (without #) 37474F
```

The brick will:
1. Generate the complete project structure
2. Run `flutter pub get`
3. Run `build_runner` to generate code
4. Display next steps

## Project Structure

The generated project follows this structure:

```
my_app/
├── lib/
│   ├── config/              # Configuration (DI, routing, environment)
│   │   ├── injection.dart
│   │   ├── env_config.dart
│   │   ├── router.dart
│   │   └── routes.dart
│   ├── core/               # Core utilities
│   │   ├── error/          # Failures and exceptions
│   │   ├── network/        # API client and interceptors
│   │   ├── services/       # Logger, connectivity
│   │   ├── storage/        # Local storage, Hive
│   │   └── utils/          # UseCase base class
│   ├── features/           # Feature modules (Clean Architecture)
│   │   └── splash/         # Example feature
│   ├── shared/             # Shared resources
│   │   ├── theme/          # App theme, colors, fonts
│   │   ├── constants/      # Constants
│   │   ├── extensions/     # Context extensions
│   │   └── widgets/        # Reusable widgets
│   ├── app.dart           # App widget
│   ├── main.dart          # Entry point
│   ├── main_dev.dart      # Dev entry point
│   ├── main_prod.dart     # Prod entry point
│   └── main_mock.dart     # Mock entry point
├── android/               # Android configuration with flavors
├── assets/                # Assets (images, translations, fonts)
├── test/                  # Tests
├── pubspec.yaml          # Dependencies
├── analysis_options.yaml # Linter rules
├── README.md             # Project README
└── CLAUDE.md             # Claude Code guidance
```

## Running the Generated Project

### Development

```bash
cd my_app
flutter run --flavor dev -t lib/main_dev.dart
```

### Production

```bash
flutter run --flavor prod -t lib/main_prod.dart
```

### Mock Mode

```bash
flutter run --flavor dev -t lib/main_mock.dart
```

## Next Steps After Generation

1. **If localization is enabled**: Download and add font files to `assets/fonts/`
   - Cairo font family (for Arabic)
   - Inter font family (for English)

2. **Update API endpoints** in `lib/config/env_config.dart` if needed

3. **Add your logo/icon** to `assets/images/`

4. **Start building features** following the Clean Architecture pattern

## Adding Features

Follow the Clean Architecture pattern:

```
lib/features/my_feature/
├── data/
│   ├── datasources/      # API and local data sources
│   ├── models/           # JSON models
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Business objects
│   ├── repositories/     # Abstract repositories
│   └── usecases/         # Business logic
└── presentation/
    ├── bloc/             # BLoC (events, states, bloc)
    ├── pages/            # Full screen widgets
    └── widgets/          # Feature-specific widgets
```

## Customization

### Colors

Colors are set during generation but can be modified in:
- `lib/shared/theme/app_colors.dart`

### Fonts

If localization is enabled, add fonts to:
- `assets/fonts/Cairo-*.ttf` (Arabic)
- `assets/fonts/Inter-*.ttf` (English)

### Dependencies

Add more dependencies in `pubspec.yaml` and run:
```bash
flutter pub get
```

## Available Commands

```bash
# Code generation
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch --delete-conflicting-outputs

# Static analysis
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Build APK
flutter build apk --flavor prod -t lib/main_prod.dart
```

## Best Practices

The generated project follows these practices:

1. **Clean Architecture** - Separation of concerns
2. **SOLID Principles** - Maintainable code
3. **Either Pattern** - Functional error handling with dartz
4. **Dependency Injection** - Testable components
5. **BLoC Pattern** - Predictable state management
6. **Multi-Environment** - Separate dev/prod configurations

## Contributing

Feel free to customize this brick for your team's specific needs!

## License

MIT License