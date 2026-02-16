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
- ✅ **JWT Authentication** - Optional token refresh mechanism with automatic retry on 401
- ✅ **FCM Notifications** - Optional Firebase Cloud Messaging support
- ✅ **Local Storage** - SharedPreferences and Hive
- ✅ **Connectivity** - Network status monitoring
- ✅ **Image Handling** - Optional image picker support
- ✅ **Maps** - Optional Google Maps and location services
- ✅ **FVM Support** - Optional Flutter Version Manager integration
- ✅ **Comprehensive Theme** - Material 3 with custom colors, fonts, and Lottie animations
- ✅ **Error Handling** - Using dartz Either pattern

## Installation

### Prerequisites

- Mason CLI (>=0.1.0): `dart pub global activate mason_cli`
- Flutter SDK ^3.7.0
- FVM (optional, for version management): `dart pub global activate fvm`

### Install the Brick

```bash
# Install from path
mason add flutter_clean_architecture --git-url https://github.com/Hayan47/Flutter-Project-Starter.git
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
9. **Include FCM Notifications** - Whether to include Firebase Cloud Messaging
10. **Use JWT Auth** - Whether to include JWT token refresh mechanism
11. **Primary Color** - Hex code without # (e.g., `1976D2`)
12. **Secondary Color** - Hex code without # (e.g., `424242`)
13. **Use FVM** - Whether to use Flutter Version Manager
14. **Flutter Version** - Flutter version for FVM (e.g., `3.24.0`, `stable`)

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
? Include FCM notifications feature? Yes
? Include JWT authentication with token refresh? Yes
? Enter primary color hex (without #) 2196F3
? Enter secondary color hex (without #) 37474F
? Use FVM for Flutter version management? Yes
? Enter Flutter version for FVM (leave empty to skip) 3.24.0
```

The brick will:
1. Generate the complete project structure
2. Setup FVM with the specified Flutter version (if enabled)
3. Run `flutter create . --platforms=android,ios` to generate platform files
4. Run `flutter pub get`
5. Run `build_runner` to generate code
6. Display next steps

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
│   │   ├── splash/         # Example feature
│   │   └── notifications/  # FCM notifications (if enabled)
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
├── assets/                # Assets
│   ├── fonts/            # Font files (Cairo, Inter)
│   ├── images/           # Image assets
│   ├── icons/            # Icon assets
│   ├── lottie/           # Lottie animations
│   └── translations/     # i18n files (if localization enabled)
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
# Without FVM
flutter run --flavor dev -t lib/main_dev.dart

# With FVM
fvm flutter run --flavor dev -t lib/main_dev.dart
```

### Production

```bash
# Without FVM
flutter run --flavor prod -t lib/main_prod.dart

# With FVM
fvm flutter run --flavor prod -t lib/main_prod.dart
```

### Mock Mode

```bash
# Without FVM
flutter run --flavor dev -t lib/main_mock.dart

# With FVM
fvm flutter run --flavor dev -t lib/main_mock.dart
```

> **Note**: If you enabled FVM during generation, prefix all `flutter` commands with `fvm`.

## FVM (Flutter Version Manager)

If you enabled FVM during project generation, the brick automatically:
- Runs `fvm use <version>` to set the Flutter version for your project
- Creates a `.fvm/` directory with the specified Flutter SDK
- Configures the project to use that specific Flutter version

### FVM Benefits

- **Team Consistency** - Everyone uses the same Flutter version
- **Multiple Projects** - Different Flutter versions for different projects
- **Easy Switching** - Switch between Flutter versions without global changes
- **Version Pinning** - Lock specific Flutter versions per project

### FVM Commands

```bash
# Check current Flutter version
fvm flutter --version

# List installed Flutter versions
fvm list

# Install a new Flutter version
fvm install 3.24.0

# Switch to a different version
fvm use 3.24.0

# Remove a Flutter version
fvm remove 3.22.0
```

### IDE Integration

**VS Code**: Install the FVM extension and it will automatically detect the `.fvm/` directory.

**Android Studio**: Configure Flutter SDK path to point to `.fvm/flutter_sdk` in the project.

## JWT Authentication (Optional)

If you enabled JWT authentication during generation, the project includes:

- **Token Storage** - Secure storage of access and refresh tokens using Hive
- **Auto-Refresh** - Automatic token refresh on 401 errors
- **Interceptors** - Dio interceptors that handle authentication flow
- **Retry Logic** - Automatic retry of failed requests after token refresh

### How It Works

1. User logs in → Access token & refresh token are stored
2. API request is made → Access token is added to headers
3. If 401 error → Refresh token is used to get new access token
4. Original request is retried with new access token
5. If refresh fails → User is logged out

This is implemented in `lib/core/network/` with Dio interceptors.

## Next Steps After Generation

1. **If localization is enabled**: Download and add font files to `assets/fonts/`
   - Cairo font family (for Arabic)
   - Inter font family (for English)

2. **If FCM notifications are enabled**:
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`
   - Configure Firebase project

3. **Update API endpoints** in `lib/config/env_config.dart` if needed

4. **Add your logo/icon** to `assets/images/`

5. **Add Lottie animations** to `assets/lottie/` for enhanced UI

6. **Start building features** following the Clean Architecture pattern

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

# Build iOS (requires macOS)
flutter build ios --flavor prod -t lib/main_prod.dart
```

> **With FVM**: Prefix all `flutter` commands with `fvm flutter`
>
> Example: `fvm flutter pub run build_runner build --delete-conflicting-outputs`

## Best Practices

The generated project follows these practices:

1. **Clean Architecture** - Separation of concerns
2. **SOLID Principles** - Maintainable code
3. **Either Pattern** - Functional error handling with dartz
4. **Dependency Injection** - Testable components
5. **BLoC Pattern** - Predictable state management
6. **Multi-Environment** - Separate dev/prod configurations

## Troubleshooting

### FVM Issues

**Problem**: `fvm: command not found`
```bash
# Solution: Install FVM globally
dart pub global activate fvm
```

**Problem**: FVM installed but still not found
```bash
# Solution: Add Dart global bin to PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
# Add this to your ~/.zshrc or ~/.bashrc for persistence
```

**Problem**: Wrong Flutter version after using FVM
```bash
# Solution: Ensure you're using fvm prefix
fvm flutter --version  # Check version
fvm use stable --force  # Force re-install
```

### Build Runner Issues

**Problem**: Code generation conflicts
```bash
# Solution: Delete generated files and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Platform Issues

**Problem**: Platform folders missing or outdated
```bash
# Solution: Recreate platform files
flutter create . --platforms=android,ios
```

### Mason Issues

**Problem**: Mason version error
```bash
# Solution: Update Mason CLI
dart pub global activate mason_cli
```

## Contributing

Feel free to customize this brick for your team's specific needs!

## License

MIT License