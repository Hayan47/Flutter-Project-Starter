{{#include_localization}}import 'package:easy_localization/easy_localization.dart';
{{/include_localization}}import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // Navigation
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(
      this,
    ).pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // MediaQuery
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // Responsive
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;
{{#include_localization}}
  // Localization
  bool get isArabic => locale.languageCode == 'ar';
  bool get isEnglish => locale.languageCode == 'en';
{{/include_localization}}
  // SnackBar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Focus
  void unfocus() => FocusScope.of(this).unfocus();
}
