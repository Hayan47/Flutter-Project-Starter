import 'dart:io';
import 'package:mason/mason.dart';

// Helper function to convert to snake_case
String toSnakeCase(String text) {
  return text
      .trim()
      // Replace spaces with underscores first
      .replaceAll(RegExp(r'\s+'), '_')
      // Replace dashes with underscores
      .replaceAll('-', '_')
      // Handle camelCase by adding underscore before uppercase letters
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => '_${match.group(0)!.toLowerCase()}',
      )
      // Remove leading underscores
      .replaceAll(RegExp(r'^_+'), '')
      // Replace multiple consecutive underscores with single underscore
      .replaceAll(RegExp(r'_+'), '_')
      // Convert to lowercase
      .toLowerCase();
}

void run(HookContext context) async {
  final projectName = context.vars['project_name'] as String;
  final includeLocalization = context.vars['include_localization'] as bool;

  final progress = context.logger.progress('Setting up project');

  try {
    // Get the project directory path
    // Mason generates in the current directory with snake_case name
    final snakeCaseName = toSnakeCase(projectName);
    final currentDir = Directory.current;
    final projectDir = Directory('${currentDir.path}/$snakeCaseName');

    // Check if directory exists
    if (!projectDir.existsSync()) {
      context.logger.warn('Project directory not found for automated setup');
      context.logger.warn('Expected: ${projectDir.path}');
      context.logger.warn('This is okay - you can set up manually');

      progress.complete('Project created (manual setup required)');
      _printNextSteps(context, snakeCaseName, includeLocalization, true);
      return;
    }

    // Run flutter pub get
    progress.update('Running flutter pub get...');
    final pubGetResult = await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: projectDir.path,
    );

    if (pubGetResult.exitCode != 0) {
      context.logger.warn('flutter pub get encountered issues');
      context.logger.warn('Please run manually: cd "$snakeCaseName" && flutter pub get');
      progress.complete('Project created (manual setup required)');
      _printNextSteps(context, snakeCaseName, includeLocalization, true);
      return;
    }

    // Run build_runner
    progress.update('Running build_runner...');
    final buildRunnerResult = await Process.run(
      'flutter',
      ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: projectDir.path,
    );

    if (buildRunnerResult.exitCode != 0) {
      context.logger.warn('build_runner had warnings (this is expected for new projects)');
    }

    progress.complete('Project setup complete!');
    _printNextSteps(context, snakeCaseName, includeLocalization, false);

  } catch (e) {
    context.logger.err('Error during setup: $e');
    progress.fail('Setup failed');

    // Still print next steps with manual instructions
    final snakeCaseName = toSnakeCase(projectName);
    _printNextSteps(context, snakeCaseName, includeLocalization, true);
  }
}

void _printNextSteps(HookContext context, String projectName, bool includeLocalization, bool needsManualSetup) {
  context.logger.info('');
  context.logger.success('🎉 Project created successfully!');
  context.logger.info('');
  context.logger.info('📂 Project: $projectName');
  context.logger.info('');

  if (needsManualSetup) {
    context.logger.info('⚠️  Manual setup required:');
    context.logger.info('  1. cd "$projectName"');
    context.logger.info('  2. flutter pub get');
    context.logger.info('  3. flutter pub run build_runner build --delete-conflicting-outputs');
    if (includeLocalization) {
      context.logger.info('  4. Download and add font files to assets/fonts/ (Cairo & Inter)');
      context.logger.info('  5. Run: flutter run --flavor dev -t lib/main_dev.dart');
    } else {
      context.logger.info('  4. Run: flutter run --flavor dev -t lib/main_dev.dart');
    }
  } else {
    context.logger.info('Next steps:');
    context.logger.info('  1. cd "$projectName"');
    if (includeLocalization) {
      context.logger.info('  2. Download and add font files to assets/fonts/ (Cairo & Inter)');
      context.logger.info('  3. Run: flutter run --flavor dev -t lib/main_dev.dart');
    } else {
      context.logger.info('  2. Run: flutter run --flavor dev -t lib/main_dev.dart');
    }
  }

  context.logger.info('');
  context.logger.info('Available commands:');
  context.logger.info('  • Dev: flutter run --flavor dev -t lib/main_dev.dart');
  context.logger.info('  • Prod: flutter run --flavor prod -t lib/main_prod.dart');
  context.logger.info('  • Mock: flutter run --flavor dev -t lib/main_mock.dart');
  context.logger.info('');
  context.logger.info('📖 See README.md and CLAUDE.md for more information');
  context.logger.info('');
}
