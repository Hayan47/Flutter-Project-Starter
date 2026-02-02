import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/shared/theme/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/shared/theme/app_fonts.dart';

class AppTheme {
  AppTheme._();

  // ============================================================================
  // Color Schemes
  // ============================================================================

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.secondary,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.accent,
    surface: AppColors.surface,
    surfaceContainerHighest: AppColors.surfaceVariant,
    error: AppColors.error,
    onPrimary: AppColors.textOnPrimary,
    onSecondary: AppColors.textOnPrimary,
    onSurface: AppColors.textPrimary,
    onError: AppColors.textOnPrimary,
    outline: AppColors.border,
    shadow: AppColors.shadow,
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primary,
    primaryContainer: AppColors.secondaryDarker,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.accent,
    surface: AppColors.darkSurface,
    surfaceContainerHighest: AppColors.secondaryDarker,
    error: AppColors.error,
    onPrimary: AppColors.textOnPrimary,
    onSecondary: AppColors.textOnPrimary,
    onSurface: AppColors.textOnPrimary,
    onError: AppColors.textOnPrimary,
    outline: Color(0xFF555555),
    shadow: AppColors.shadow,
  );

  // ============================================================================
  // Public Theme Getters
  // ============================================================================

  /// Light theme with locale support
  static ThemeData lightTheme(Locale locale) {
    return _baseTheme(
      locale: locale,
      colorScheme: _lightColorScheme,
      brightness: Brightness.light,
    );
  }

  /// Dark theme with locale support
  static ThemeData darkTheme(Locale locale) {
    return _baseTheme(
      locale: locale,
      colorScheme: _darkColorScheme,
      brightness: Brightness.dark,
    );
  }

  // Legacy getters for backward compatibility
  static ThemeData get lightThemeDefault => lightTheme(const Locale('en'));
  static ThemeData get darkThemeDefault => darkTheme(const Locale('en'));

  // ============================================================================
  // Base Theme
  // ============================================================================

  static ThemeData _baseTheme({
    required Locale locale,
    required ColorScheme colorScheme,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppFonts.getFontFamily(locale),
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,

      // Component Themes
      appBarTheme: _appBarTheme(locale, colorScheme, isDark),
      cardTheme: _cardTheme(colorScheme, isDark),
      elevatedButtonTheme: _elevatedButtonTheme(locale, colorScheme),
      textButtonTheme: _textButtonTheme(locale, colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(locale, colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme, isDark),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      dividerTheme: _dividerTheme(isDark),
      iconTheme: _iconTheme(colorScheme, isDark),

      // Text Theme
      textTheme: _textTheme(locale, colorScheme, isDark),
    );
  }

  // ============================================================================
  // Component Themes
  // ============================================================================

  static AppBarTheme _appBarTheme(
    Locale locale,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return AppBarTheme(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.secondary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppFonts.titleLarge(
        locale,
      ).copyWith(color: AppColors.textOnPrimary, fontWeight: FontWeight.w600),
      iconTheme: const IconThemeData(color: AppColors.textOnPrimary, size: 24),
    );
  }

  static CardThemeData _cardTheme(ColorScheme colorScheme, bool isDark) {
    return CardThemeData(
      color: isDark ? AppColors.darkSurface : AppColors.card,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(
    Locale locale,
    ColorScheme colorScheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shadowColor: AppColors.shadow,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppFonts.button(locale),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(
    Locale locale,
    ColorScheme colorScheme,
  ) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: AppFonts.button(locale),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(
    Locale locale,
    ColorScheme colorScheme,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppFonts.button(locale),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  static FloatingActionButtonThemeData _fabTheme(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 4,
    );
  }

  static DividerThemeData _dividerTheme(bool isDark) {
    return DividerThemeData(
      color: isDark ? const Color(0xFF555555) : AppColors.divider,
      thickness: 1,
      space: 1,
    );
  }

  static IconThemeData _iconTheme(ColorScheme colorScheme, bool isDark) {
    return IconThemeData(
      color: isDark ? AppColors.textOnPrimary : AppColors.textSecondary,
      size: 24,
    );
  }

  // ============================================================================
  // Text Theme
  // ============================================================================

  static TextTheme _textTheme(
    Locale locale,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final primaryTextColor =
        isDark ? AppColors.textOnPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark
            ? AppColors.textOnPrimary.withValues(alpha: 0.7)
            : AppColors.textSecondary;
    final tertiaryTextColor =
        isDark
            ? AppColors.textOnPrimary.withValues(alpha: 0.5)
            : AppColors.textTertiary;

    return TextTheme(
      // Display styles
      displayLarge: AppFonts.displayLarge(
        locale,
      ).copyWith(color: primaryTextColor),
      displayMedium: AppFonts.displayMedium(
        locale,
      ).copyWith(color: primaryTextColor),
      displaySmall: AppFonts.displaySmall(
        locale,
      ).copyWith(color: primaryTextColor),

      // Headline styles
      headlineLarge: AppFonts.headlineLarge(
        locale,
      ).copyWith(color: primaryTextColor),
      headlineMedium: AppFonts.headlineMedium(
        locale,
      ).copyWith(color: primaryTextColor),
      headlineSmall: AppFonts.headlineSmall(
        locale,
      ).copyWith(color: primaryTextColor),

      // Title styles
      titleLarge: AppFonts.titleLarge(locale).copyWith(color: primaryTextColor),
      titleMedium: AppFonts.titleMedium(
        locale,
      ).copyWith(color: primaryTextColor),
      titleSmall: AppFonts.titleSmall(locale).copyWith(color: primaryTextColor),

      // Body styles
      bodyLarge: AppFonts.bodyLargeStyle(
        locale,
      ).copyWith(color: primaryTextColor),
      bodyMedium: AppFonts.bodyMediumStyle(
        locale,
      ).copyWith(color: primaryTextColor),
      bodySmall: AppFonts.bodySmallStyle(
        locale,
      ).copyWith(color: secondaryTextColor),

      // Label styles
      labelLarge: AppFonts.labelLarge(locale).copyWith(color: primaryTextColor),
      labelMedium: AppFonts.labelMedium(
        locale,
      ).copyWith(color: secondaryTextColor),
      labelSmall: AppFonts.labelSmall(
        locale,
      ).copyWith(color: tertiaryTextColor),
    );
  }
}
