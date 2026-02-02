# Mason Brick Usage Guide

## What Has Been Created

Your Mason brick has been successfully created at:
```
/Users/jhussein/StudioProjects/flutter_clean_architecture_brick
```

## Brick Structure

```
flutter_clean_architecture_brick/
├── brick.yaml                    # Brick configuration with variables
├── README.md                     # Brick documentation
├── USAGE.md                      # This file
├── __brick__/                    # Template files
│   └── {{project_name.snakeCase}}/
│       ├── lib/
│       │   ├── config/           # DI, routing, environment
│       │   ├── core/             # Core utilities
│       │   ├── features/         # Example splash feature
│       │   ├── shared/           # Theme, widgets, extensions
│       │   └── main*.dart        # Entry points (dev, prod, mock)
│       ├── android/              # Android with flavors
│       ├── assets/               # Translations, images, icons
│       ├── pubspec.yaml          # Templated dependencies
│       ├── analysis_options.yaml
│       ├── README.md             # Project README
│       └── CLAUDE.md             # Claude Code guidance
└── hooks/                        # Post-generation hooks
    ├── post_gen.dart             # Runs pub get & build_runner
    └── pubspec.yaml
```

## Installation

### Option 1: Install from Local Path

```bash
mason add flutter_clean_architecture --path /Users/jhussein/StudioProjects/flutter_clean_architecture_brick
```

### Option 2: Install from Git (After Publishing)

1. Create a Git repository
2. Push the brick to GitHub:
```bash
cd /Users/jhussein/StudioProjects/flutter_clean_architecture_brick
git init
git add .
git commit -m "Initial commit: Flutter Clean Architecture brick"
git remote add origin <your-repo-url>
git push -u origin main
```

3. Install from Git:
```bash
mason add flutter_clean_architecture --git-url <your-repo-url>
```

## Using the Brick

### Quick Start

```bash
# Navigate to where you want to create projects
cd /Users/jhussein/StudioProjects

# Generate a new project
mason make flutter_clean_architecture
```

### Interactive Prompts

You'll be asked:

1. **project_name**: Snake case (e.g., `my_app`)
2. **project_description**: Brief description
3. **organization**: Reverse domain (e.g., `com.mycompany`)
4. **dev_api_url**: Dev API URL (default: https://dev-api.example.com)
5. **prod_api_url**: Prod API URL (default: https://api.example.com)
6. **include_localization**: true/false
7. **include_maps**: true/false
8. **include_image_picker**: true/false
9. **primary_color**: Hex without # (e.g., `1976D2`)
10. **secondary_color**: Hex without # (e.g., `424242`)

### Non-Interactive Mode

Create a `config.json`:

```json
{
  "project_name": "my_awesome_app",
  "project_description": "An awesome Flutter app",
  "organization": "com.mycompany",
  "dev_api_url": "https://dev-api.mycompany.com",
  "prod_api_url": "https://api.mycompany.com",
  "include_localization": true,
  "include_maps": false,
  "include_image_picker": true,
  "primary_color": "2196F3",
  "secondary_color": "37474F"
}
```

Then run:
```bash
mason make flutter_clean_architecture --config-path config.json
```

## What Gets Generated

### Core Infrastructure

✅ **Clean Architecture Structure**
- Domain, Data, Presentation layers
- Repository pattern
- Use case pattern

✅ **State Management**
- flutter_bloc setup
- BLoC pattern ready

✅ **Dependency Injection**
- get_it configured
- injectable setup
- Auto-generated injection code

✅ **Networking**
- Dio client with interceptors
- API error handling
- Connectivity monitoring

✅ **Storage**
- SharedPreferences wrapper
- Hive service

✅ **Routing**
- go_router configured
- Example routes

✅ **Multi-Environment**
- Dev, Prod, Mock flavors
- Environment-based configs
- Android flavor setup

✅ **Theme System**
- Material 3
- Custom colors (from your input)
- Light & dark modes
- Locale-aware fonts

✅ **Utilities**
- Logger service
- Context extensions
- Error handling with Either

### Conditional Features

Based on your selections:

- **Localization**: easy_localization + English/Arabic translations
- **Maps**: Google Maps, Geolocator, Geocoding
- **Image Picker**: Image picker and file handling

## After Generation

### 1. Navigate to Project

```bash
cd my_awesome_app
```

### 2. Add Fonts (if localization enabled)

Download and add to `assets/fonts/`:
- Cairo font family (for Arabic)
- Inter font family (for English)

### 3. Run the App

```bash
# Development
flutter run --flavor dev -t lib/main_dev.dart

# Production
flutter run --flavor prod -t lib/main_prod.dart

# Mock mode (no backend needed)
flutter run --flavor dev -t lib/main_mock.dart
```

### 4. Build for Release

```bash
# Android APK
flutter build apk --flavor prod -t lib/main_prod.dart

# Android App Bundle
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

## Common Tasks

### Add a New Feature

1. Create directory structure:
```bash
mkdir -p lib/features/my_feature/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
```

2. Follow Clean Architecture:
   - Define entities in `domain/entities/`
   - Create repository interface in `domain/repositories/`
   - Create use cases in `domain/usecases/`
   - Implement models in `data/models/`
   - Implement data sources in `data/datasources/`
   - Implement repository in `data/repositories/`
   - Create BLoC in `presentation/bloc/`
   - Create pages/widgets in `presentation/`

3. Register dependencies in `lib/config/injection.dart`

4. Add routes in `lib/config/router.dart`

5. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Update API URLs

Edit `lib/config/env_config.dart`:
```dart
static String get baseUrl {
  switch (_environment) {
    case Environment.dev:
      return 'https://your-dev-api.com';
    case Environment.prod:
      return 'https://your-prod-api.com';
    case Environment.mock:
      return 'https://mock-api.com';
  }
}
```

### Add Translation Keys

Edit `assets/translations/en.json` and `assets/translations/ar.json`:
```json
{
  "new_key": "New Value",
  "another_key": "Another Value"
}
```

Use in code:
```dart
Text('new_key'.tr())
```

## Customizing the Brick

### Modify Variables

Edit `/Users/jhussein/StudioProjects/flutter_clean_architecture_brick/brick.yaml`:

```yaml
vars:
  your_new_variable:
    type: string
    description: Your description
    prompt: Your prompt
    default: default_value
```

### Modify Templates

Edit files in `__brick__/{{project_name.snakeCase}}/`:

Use Mason templating:
- `{{variable_name}}` - Insert variable
- `{{variable.snakeCase()}}` - Transform to snake_case
- `{{variable.pascalCase()}}` - Transform to PascalCase
- `{{variable.titleCase()}}` - Transform to Title Case
- `{{#if_condition}}...{{/if_condition}}` - Conditional
- `{{^if_condition}}...{{/if_condition}}` - Negated conditional

Example:
```dart
import 'package:{{project_name.snakeCase()}}/core/error/failures.dart';

{{#include_localization}}
import 'package:easy_localization/easy_localization.dart';
{{/include_localization}}
```

### Modify Post-Gen Hook

Edit `/Users/jhussein/StudioProjects/flutter_clean_architecture_brick/hooks/post_gen.dart` to add custom logic.

## Troubleshooting

### Build Runner Errors After Generation

This is normal for a new project. Run manually:
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Font Not Found (if localization enabled)

Add font files to `assets/fonts/` directory:
- Cairo-Regular.ttf, Cairo-Medium.ttf, etc.
- Inter-Regular.ttf, Inter-Medium.ttf, etc.

### Flavor Issues on Android

Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter run --flavor dev -t lib/main_dev.dart
```

## Best Practices

1. **Always run build_runner** after modifying injectable classes
2. **Use const constructors** where possible
3. **Follow Clean Architecture** - keep layers separated
4. **Test your code** - write unit tests for use cases and BLoCs
5. **Use Either for error handling** - avoid throwing exceptions
6. **Check connectivity** before API calls
7. **Localize all user-facing strings** (if localization enabled)

## Need Help?

- Check the generated `README.md` in your project
- Check the generated `CLAUDE.md` for Claude Code guidance
- Review the brick's README: `/Users/jhussein/StudioProjects/flutter_clean_architecture_brick/README.md`

## Next Steps

1. **Test the brick**: Generate a sample project to verify everything works
2. **Customize**: Modify the brick to fit your team's needs
3. **Share**: Publish to Git for easy sharing
4. **Iterate**: Add more features as your team grows

---

**Brick Location**: `/Users/jhussein/StudioProjects/flutter_clean_architecture_brick`

Happy coding! 🚀