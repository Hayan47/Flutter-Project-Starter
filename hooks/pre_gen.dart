import 'package:mason/mason.dart';

/// Dart reserved words that cannot be used as a package name.
const _reservedWords = {
  'abstract', 'as', 'assert', 'async', 'await', 'break', 'case', 'catch',
  'class', 'const', 'continue', 'covariant', 'default', 'deferred', 'do',
  'dynamic', 'else', 'enum', 'export', 'extends', 'extension', 'external',
  'factory', 'false', 'final', 'finally', 'for', 'function', 'get', 'hide',
  'if', 'implements', 'import', 'in', 'interface', 'is', 'late', 'library',
  'mixin', 'new', 'null', 'on', 'operator', 'part', 'required', 'rethrow',
  'return', 'set', 'show', 'static', 'super', 'switch', 'sync', 'this',
  'throw', 'true', 'try', 'typedef', 'var', 'void', 'while', 'with', 'yield',
  // Names that clash with packages this template depends on.
  'flutter', 'flutter_test', 'test',
};

final _folderNameRegExp = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.-]*$');
final _packageNameRegExp = RegExp(r'^[a-z][a-z0-9_]*$');
// Android applicationId rules (also valid as an iOS bundle ID):
// at least two segments, each starting with a letter, letters/digits/_ only.
final _appIdRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$');
final _hexColorRegExp = RegExp(r'^[0-9a-fA-F]{6}$');

/// Java/Kotlin keywords are not allowed as applicationId segments.
const _javaKeywords = {
  'abstract', 'assert', 'boolean', 'break', 'byte', 'case', 'catch', 'char',
  'class', 'const', 'continue', 'default', 'do', 'double', 'else', 'enum',
  'extends', 'false', 'final', 'finally', 'float', 'for', 'goto', 'if',
  'implements', 'import', 'instanceof', 'int', 'interface', 'long', 'native',
  'new', 'null', 'package', 'private', 'protected', 'public', 'return',
  'short', 'static', 'strictfp', 'super', 'switch', 'synchronized', 'this',
  'throw', 'throws', 'transient', 'true', 'try', 'void', 'volatile', 'while',
  'fun', 'in', 'is', 'object', 'typealias', 'val', 'var', 'when',
};

void run(HookContext context) {
  final logger = context.logger;
  final errors = <String>[];

  // Project name -> used as-is for the folder, snake_case for the Dart package.
  final projectName = (context.vars['project_name'] as String? ?? '').trim();
  final packageName = projectName.snakeCase;
  if (projectName.isEmpty) {
    errors.add('project_name must not be empty.');
  } else if (!_folderNameRegExp.hasMatch(projectName)) {
    errors.add(
      'project_name "$projectName" may only contain letters, digits, "-", "_" '
      'and ".", e.g. my-app',
    );
  } else if (!_packageNameRegExp.hasMatch(packageName)) {
    errors.add(
      'project_name "$projectName" becomes package name "$packageName", which '
      'is not a valid Dart package name (it must start with a letter).',
    );
  } else if (_reservedWords.contains(packageName)) {
    errors.add('project_name "$packageName" is a reserved word.');
  } else {
    context.vars['project_name'] = projectName;
  }

  // App ID -> Android applicationId/namespace and iOS bundle ID.
  final appId = (context.vars['app_id'] as String? ?? '').trim();
  final badSegment = appId.split('.').where(_javaKeywords.contains).firstOrNull;
  if (!_appIdRegExp.hasMatch(appId)) {
    errors.add(
      'app_id "$appId" must look like com.company.app: at least two parts '
      'separated by dots, each starting with a letter, using only letters, '
      'digits and "_".',
    );
  } else if (badSegment != null) {
    errors.add('app_id "$appId" contains the reserved word "$badSegment".');
  } else {
    context.vars['app_id'] = appId;
    // Used for the MainActivity.kt folder: com.company.app -> com/company/app
    context.vars['app_id_path'] = appId.replaceAll('.', '/');
  }

  // API URLs.
  for (final key in ['dev_api_url', 'prod_api_url']) {
    final raw = (context.vars[key] as String? ?? '').trim();
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme || !uri.scheme.startsWith('http') || uri.host.isEmpty) {
      errors.add('$key "$raw" must be a full http(s) URL, e.g. https://api.example.com');
    } else {
      // Strip trailing slash so `baseUrl + '/path'` never yields `//path`.
      context.vars[key] = raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
    }
  }

  // Colors -> accept "#1976D2" or "1976D2", store without "#".
  for (final key in ['primary_color', 'secondary_color']) {
    final raw = (context.vars[key] as String? ?? '').trim().replaceFirst('#', '');
    if (!_hexColorRegExp.hasMatch(raw)) {
      errors.add('$key "${context.vars[key]}" must be a 6-digit hex color, e.g. 1976D2');
    } else {
      context.vars[key] = raw.toUpperCase();
    }
  }

  // FVM version only matters when FVM is enabled.
  final useFvm = context.vars['use_fvm'] as bool? ?? false;
  final flutterVersion = (context.vars['flutter_version'] as String? ?? '').trim();
  context.vars['flutter_version'] = flutterVersion.isEmpty ? 'stable' : flutterVersion;
  if (!useFvm && flutterVersion.isNotEmpty && flutterVersion != 'stable') {
    logger.detail('flutter_version is ignored because use_fvm is false.');
  }

  if (errors.isEmpty) {
    logger
      ..info('📂 Folder:       $projectName')
      ..info('📦 Package name: $packageName')
      ..info('🆔 App ID:       $appId');
  }

  if (errors.isNotEmpty) {
    for (final error in errors) {
      logger.err('✗ $error');
    }
    throw Exception('Invalid brick variables. Fix the values above and try again.');
  }
}
