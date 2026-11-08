# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-11-08

### Breaking
- The project folder now keeps `project_name` exactly as entered (e.g. `my-app`). The Dart package name is still derived as snake_case (`my_app`).
- `organization` was replaced by `app_id`: the full Android applicationId/namespace and iOS bundle ID (e.g. `com.company.app`). Update any saved config files.

### Added
- Optional FCM notifications feature (`include_fcm_notifications`) with local notifications, notification list page and mock data source
- Optional FVM support (`use_fvm`, `flutter_version`)
- Multi-flavor launcher icons (dev, mock, prod) generated automatically after creation
- Custom snackbar widget, empty list widget, dialog, bundled Cairo/Inter fonts and Lottie assets
- `pre_gen` hook that validates `project_name`, `app_id`, API URLs and colors before any file is written
  - Colors may now be entered with or without `#`; trailing slashes are stripped from API URLs
- iOS usage descriptions for camera/photo library (image picker) and location (maps), and `UIBackgroundModes` for FCM
- Android location permissions and Google Maps API key placeholder when maps are enabled
- Generated projects now include a passing `EnvConfig` test

### Fixed
- iOS bundle ID was always `com.example.<camelCaseName>` because `flutter create` ran without `--org`; it now matches `app_id`
- Android `MainActivity` was always generated in `com.example.<name>`, which crashed at launch whenever the organization wasn't `com.example`; it now ships in the `app_id` package
- `build_runner` failed in every generated project: removed unused `hive_generator` and bumped `build_runner`, `injectable_generator`, `json_serializable`, `retrofit` and `retrofit_generator`
- `context.isArabic` / `context.isEnglish` did not compile when localization was disabled
- `flutter create`'s default counter test (referencing a missing `MyApp` counter) is removed after setup
- Missing `assets/images/` directory caused an analyzer warning
- Gradle cache files were bundled in the template and copied into every generated project
- Post-gen hook now uses mason's own `snakeCase` so it always finds the generated folder, returns a proper `Future`, and runs `dart run build_runner` instead of the deprecated `flutter pub run`
- Mock entry point now runs with `--flavor mock` (matching its Android flavor and icon)
- API URLs in generated README/CLAUDE.md were HTML-escaped (`&` → `&amp;`)
- Replaced deprecated `textScaleFactor` with `TextScaler.clamp`
- Removed unused imports and dead null-aware expressions

### Changed
- Hook build artifacts and IDE files are no longer tracked in git

## [1.0.2] - 2026-02-10

### Added
- Optional JWT authentication with automatic token refresh (`use_jwt_auth`)

## [1.0.1] - 2026-02-10

### Fixed
- App display name configuration for Android and iOS

## [1.0.0] - 2026-02-09

### Added
- Initial release of Flutter Clean Architecture brick
- Clean Architecture layer structure (Data, Domain, Presentation)
- BLoC state management setup
- Multi-environment configuration (dev, prod)
- Core infrastructure:
  - Network layer with Dio
  - Dependency injection with GetIt
  - Error handling and failures
  - Routing with Go Router
  - Theme management
- Optional features:
  - Localization support (English & Arabic)
  - Google Maps and location services
  - Image picker and file handling
- Customizable color scheme
- Comprehensive project template structure