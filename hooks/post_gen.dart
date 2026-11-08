import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  // Folder is `{{project_name}}` (as entered); Dart package is snake_case.
  final projectName = context.vars['project_name'] as String;
  final appId = context.vars['app_id'] as String;
  final useFvm = context.vars['use_fvm'] as bool? ?? false;
  final flutterVersion = context.vars['flutter_version'] as String? ?? 'stable';

  final setup = _Setup(
    context: context,
    projectName: projectName,
    appId: appId,
    useFvm: useFvm,
    flutterVersion: flutterVersion,
  );

  final projectDir = Directory('${Directory.current.path}/$projectName');
  if (!projectDir.existsSync()) {
    context.logger
      ..warn('Project directory not found for automated setup')
      ..warn('Expected: ${projectDir.path}');
    setup.printNextSteps(needsManualSetup: true);
    return;
  }

  final ok = await setup.runAll(projectDir.path);
  setup.printNextSteps(needsManualSetup: !ok);
}

class _Setup {
  _Setup({
    required this.context,
    required this.projectName,
    required this.appId,
    required this.useFvm,
    required this.flutterVersion,
  });

  final HookContext context;
  final String projectName;
  final String appId;
  final bool useFvm;
  final String flutterVersion;

  Logger get logger => context.logger;

  /// `flutter` or `fvm flutter`
  String get flutter => useFvm ? 'fvm flutter' : 'flutter';

  /// `dart` or `fvm dart`
  String get dart => useFvm ? 'fvm dart' : 'dart';

  /// `flutter create` would otherwise derive the package name from the folder
  /// (invalid for names like `my-app`) and default the org to com.example.
  String get createCommand {
    final org = appId.substring(0, appId.lastIndexOf('.'));
    return '$flutter create . --platforms=android,ios '
        '--project-name ${projectName.snakeCase} --org $org';
  }

  /// Runs every setup step. Returns false if a required step failed.
  Future<bool> runAll(String workingDirectory) async {
    if (useFvm &&
        !await _step(
          'Setting up FVM with Flutter $flutterVersion',
          'fvm use $flutterVersion --force',
          workingDirectory,
          hint: 'Make sure FVM is installed: dart pub global activate fvm',
        )) {
      return false;
    }

    if (!await _step(
      'Creating Android and iOS platform files',
      createCommand,
      workingDirectory,
    )) {
      return false;
    }

    _applyAppId(workingDirectory);

    // `flutter create` adds a counter-app test that references a `MyApp`
    // counter widget which doesn't exist in this template.
    final defaultTest = File('$workingDirectory/test/widget_test.dart');
    if (defaultTest.existsSync() &&
        defaultTest.readAsStringSync().contains('Counter increments smoke test')) {
      defaultTest.deleteSync();
    }

    final required = [
      ('Running $flutter pub get', '$flutter pub get'),
      ('Running build_runner', '$dart run build_runner build --delete-conflicting-outputs'),
    ];
    for (final (label, command) in required) {
      if (!await _step(label, command, workingDirectory)) return false;
    }

    // Icons are nice to have; don't fail the whole setup if they break.
    await _step(
      'Generating launcher icons for all flavors',
      '$dart run flutter_launcher_icons',
      workingDirectory,
      optional: true,
    );
    return true;
  }

  /// Makes Android and iOS use exactly [appId].
  void _applyAppId(String workingDirectory) {
    // iOS: flutter create writes `<org>.<camelCaseName>` as the bundle ID.
    final pbxproj = File('$workingDirectory/ios/Runner.xcodeproj/project.pbxproj');
    if (pbxproj.existsSync()) {
      final updated = pbxproj.readAsStringSync().replaceAllMapped(
        RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = [^;]*?(\.RunnerTests)?;'),
        (m) => 'PRODUCT_BUNDLE_IDENTIFIER = $appId${m[1] ?? ''};',
      );
      pbxproj.writeAsStringSync(updated);
    }

    // Android: the brick ships MainActivity.kt in the app ID's package; remove
    // the extra one flutter create generates under `<org>/<package_name>/`.
    final kotlinDir = Directory('$workingDirectory/android/app/src/main/kotlin');
    if (!kotlinDir.existsSync()) return;
    final expected = '${kotlinDir.path}/${appId.replaceAll('.', '/')}/MainActivity.kt';
    for (final file in kotlinDir.listSync(recursive: true).whereType<File>()) {
      if (file.path.endsWith('/MainActivity.kt') && file.path != expected) {
        file.deleteSync();
        _deleteEmptyParents(file.parent, stopAt: kotlinDir);
      }
    }
  }

  void _deleteEmptyParents(Directory dir, {required Directory stopAt}) {
    var current = dir;
    while (current.path != stopAt.path && current.listSync().isEmpty) {
      current.deleteSync();
      current = current.parent;
    }
  }

  Future<bool> _step(
    String label,
    String command,
    String workingDirectory, {
    bool optional = false,
    String? hint,
  }) async {
    final progress = logger.progress(label);
    final parts = command.split(' ');
    try {
      final result = await Process.run(
        parts.first,
        parts.skip(1).toList(),
        workingDirectory: workingDirectory,
        runInShell: Platform.isWindows,
      );
      if (result.exitCode == 0) {
        progress.complete(label);
        return true;
      }
      final message = '$label failed (exit code ${result.exitCode})';
      optional ? progress.complete('$message, skipped') : progress.fail(message);
      final stderr = '${result.stderr}'.trim();
      if (stderr.isNotEmpty) logger.detail(stderr);
    } on ProcessException catch (e) {
      final message = '$label failed: ${e.executable} not found';
      optional ? progress.complete('$message, skipped') : progress.fail(message);
    }
    if (hint != null) logger.info(hint);
    logger.info('  Run manually: cd "$projectName" && $command');
    return false;
  }

  void printNextSteps({required bool needsManualSetup}) {
    final steps = [
      'cd "$projectName"',
      if (needsManualSetup) ...[
        if (useFvm) 'fvm use $flutterVersion',
        createCommand,
        'Set the iOS bundle ID to $appId (Xcode → Runner → Signing & Capabilities)',
        '$flutter pub get',
        '$dart run build_runner build --delete-conflicting-outputs',
      ],
      '$flutter run --flavor dev -t lib/main_dev.dart',
    ];

    logger
      ..info('')
      ..success(needsManualSetup
          ? '📂 Project files created. A few manual steps are still needed:'
          : '🎉 Project $projectName created successfully!')
      ..info('');
    if (useFvm) {
      logger
        ..info('🔧 Flutter version: $flutterVersion (via FVM)')
        ..info('');
    }

    logger.info(needsManualSetup ? '⚠️  Manual setup:' : 'Next steps:');
    for (var i = 0; i < steps.length; i++) {
      logger.info('  ${i + 1}. ${steps[i]}');
    }

    logger
      ..info('')
      ..info('Available commands:')
      ..info('  • Dev:  $flutter run --flavor dev -t lib/main_dev.dart')
      ..info('  • Prod: $flutter run --flavor prod -t lib/main_prod.dart')
      ..info('  • Mock: $flutter run --flavor mock -t lib/main_mock.dart')
      ..info('')
      ..info('🎨 Replace the placeholder icons in assets/icons/ with your own:')
      ..info('   app_icon_dev.png, app_icon_mock.png, app_icon.png')
      ..info('   then run: $dart run flutter_launcher_icons')
      ..info('');
    if (context.vars['include_maps'] == true) {
      logger
        ..info('🗺️  Add your Google Maps API key to android/app/src/main/AndroidManifest.xml')
        ..info('   and ios/Runner/AppDelegate.swift (GMSServices.provideAPIKey).')
        ..info('');
    }
    if (context.vars['include_fcm_notifications'] == true) {
      logger
        ..info('🔔 FCM: add google-services.json to android/app/ and')
        ..info('   GoogleService-Info.plist to ios/Runner/.')
        ..info('');
    }
    logger
      ..info('📖 See README.md and CLAUDE.md for more information')
      ..info('');
  }
}
