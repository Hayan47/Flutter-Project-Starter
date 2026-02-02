{{#include_localization}}import 'package:easy_localization/easy_localization.dart';
{{/include_localization}}import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/config/router.dart';
import 'package:{{project_name.snakeCase()}}/shared/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
        ),
      ),
      child: MaterialApp.router(
        title: '{{project_name.titleCase()}}',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme({{#include_localization}}context.locale{{/include_localization}}{{^include_localization}}const Locale('en'){{/include_localization}}),
        darkTheme: AppTheme.darkTheme({{#include_localization}}context.locale{{/include_localization}}{{^include_localization}}const Locale('en'){{/include_localization}}),
        themeMode: ThemeMode.light,{{#include_localization}}
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,{{/include_localization}}
        routerConfig: AppRouter.router,
      ),
    );
  }
}
