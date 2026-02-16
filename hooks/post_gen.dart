import 'dart:io';
import 'package:mason/mason.dart';

String toSnakeCase(String text) {
  return text
      .trim()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll('-', '_')
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => '_${match.group(0)!.toLowerCase()}',
      )
      .replaceAll(RegExp(r'^_+'), '')
      .replaceAll(RegExp(r'_+'), '_')
      .toLowerCase();
}

void run(HookContext context) async {
  final projectName = context.vars['project_name'] as String;
  final includeLocalization = context.vars['include_localization'] as bool;
  final useFvm = context.vars['use_fvm'] as bool? ?? false;
  final flutterVersion = context.vars['flutter_version'] as String? ?? 'stable';

  final progress = context.logger.progress('Setting up project');

  try {
    final snakeCaseName = toSnakeCase(projectName);
    final currentDir = Directory.current;
    final projectDir = Directory('${currentDir.path}/$snakeCaseName');

    if (!projectDir.existsSync()) {
      context.logger.warn('Project directory not found for automated setup');
      context.logger.warn('Expected: ${projectDir.path}');
      context.logger.warn('This is okay - you can set up manually');

      progress.complete('Project created (manual setup required)');
      _printNextSteps(context, snakeCaseName, includeLocalization, useFvm, flutterVersion, true);
      return;
    }

    if (useFvm) {
      progress.update('Setting up FVM with Flutter $flutterVersion...');
      final fvmUseResult = await Process.run(
        'fvm',
        ['use', flutterVersion, '--force'],
        workingDirectory: projectDir.path,
      );

      if (fvmUseResult.exitCode != 0) {
        context.logger.warn('FVM setup encountered issues');
        context.logger.warn('stderr: ${fvmUseResult.stderr}');
        context.logger.warn('Please ensure FVM is installed: dart pub global activate fvm');
        context.logger.warn('Then run manually: cd "$snakeCaseName" && fvm use $flutterVersion');
        progress.complete('Project created (manual FVM setup required)');
        _printNextSteps(context, snakeCaseName, includeLocalization, useFvm, flutterVersion, true);
        return;
      }
    }

    final flutterCmd = useFvm ? 'fvm' : 'flutter';
    final flutterArgs = useFvm ? ['flutter'] : <String>[];

    progress.update('Creating platform files for Android and iOS...');
    final createResult = await Process.run(
      flutterCmd,
      [...flutterArgs, 'create', '.', '--platforms=android,ios'],
      workingDirectory: projectDir.path,
    );

    if (createResult.exitCode != 0) {
      context.logger.warn('flutter create encountered issues');
      context.logger.warn('Please run manually: cd "$snakeCaseName" && ${useFvm ? 'fvm flutter' : 'flutter'} create . --platforms=android,ios');
      progress.complete('Project created (manual setup required)');
      _printNextSteps(context, snakeCaseName, includeLocalization, useFvm, flutterVersion, true);
      return;
    }

    progress.update('Running ${useFvm ? 'fvm flutter' : 'flutter'} pub get...');
    final pubGetResult = await Process.run(
      flutterCmd,
      [...flutterArgs, 'pub', 'get'],
      workingDirectory: projectDir.path,
    );

    if (pubGetResult.exitCode != 0) {
      context.logger.warn('flutter pub get encountered issues');
      context.logger.warn('Please run manually: cd "$snakeCaseName" && ${useFvm ? 'fvm flutter' : 'flutter'} pub get');
      progress.complete('Project created (manual setup required)');
      _printNextSteps(context, snakeCaseName, includeLocalization, useFvm, flutterVersion, true);
      return;
    }

    progress.update('Running build_runner...');
    final buildRunnerResult = await Process.run(
      flutterCmd,
      [...flutterArgs, 'pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: projectDir.path,
    );

    if (buildRunnerResult.exitCode != 0) {
      context.logger.warn('build_runner had warnings (this is expected for new projects)');
    }

    progress.complete('Project setup complete!');
    _printNextSteps(context, snakeCaseName, includeLocalization, useFvm, flutterVersion, false);

  } catch (e) {
    context.logger.err('Error during setup: $e');
    progress.fail('Setup failed');
    final snakeCaseName = toSnakeCase(projectName);
    _printNextSteps(context, snakeCaseName, includeLocalization, useFvm, flutterVersion, true);
  }
}

void _printNextSteps(HookContext context, String projectName, bool includeLocalization, bool useFvm, String flutterVersion, bool needsManualSetup) {
  final flutterCmd = useFvm ? 'fvm flutter' : 'flutter';

  context.logger.info('');
  context.logger.success('🎉 Project created successfully!');
  context.logger.info('');
  context.logger.info('📂 Project: $projectName');
  if (useFvm) {
    context.logger.info('🔧 Flutter Version: $flutterVersion (via FVM)');
  }
  context.logger.info('');

  if (needsManualSetup) {
    context.logger.info('⚠️  Manual setup required:');
    context.logger.info('  1. cd "$projectName"');
    if (useFvm) {
      context.logger.info('  2. fvm use $flutterVersion');
      context.logger.info('  3. $flutterCmd create . --platforms=android,ios');
      context.logger.info('  4. $flutterCmd pub get');
      context.logger.info('  5. $flutterCmd pub run build_runner build --delete-conflicting-outputs');
      context.logger.info('  6. Run: $flutterCmd run --flavor dev -t lib/main_dev.dart');
    } else {
      context.logger.info('  2. flutter create . --platforms=android,ios');
      context.logger.info('  3. flutter pub get');
      context.logger.info('  4. flutter pub run build_runner build --delete-conflicting-outputs');
      context.logger.info('  5. Run: flutter run --flavor dev -t lib/main_dev.dart');
    }
  } else {
    context.logger.info('Next steps:');
    context.logger.info('  1. cd "$projectName"');
    context.logger.info('  2. Run: $flutterCmd run --flavor dev -t lib/main_dev.dart');
  }

  context.logger.info('');
  context.logger.info('Available commands:');
  context.logger.info('  • Dev: $flutterCmd run --flavor dev -t lib/main_dev.dart');
  context.logger.info('  • Prod: $flutterCmd run --flavor prod -t lib/main_prod.dart');
  context.logger.info('  • Mock: $flutterCmd run --flavor dev -t lib/main_mock.dart');
  context.logger.info('');
  if (useFvm) {
    context.logger.info('💡 Tip: All flutter commands should be prefixed with "fvm flutter"');
    context.logger.info('');
  }
  context.logger.info('📖 See README.md and CLAUDE.md for more information');
  context.logger.info('');
}
