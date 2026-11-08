import 'package:flutter/material.dart';

class AppFonts {
  AppFonts._();

  // Font Families{{#include_localization}}
  static const String arabic = 'Cairo';{{/include_localization}}
  static const String english = 'Inter'; // Change to your preferred English font

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Font Sizes
  static const double h1 = 32.0;
  static const double h2 = 28.0;
  static const double h3 = 24.0;
  static const double h4 = 20.0;
  static const double h5 = 18.0;
  static const double h6 = 16.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
  static const double caption = 11.0;

  // Get font family based on locale
  static String getFontFamily(Locale locale) {
    {{#include_localization}}return locale.languageCode == 'ar' ? arabic : english;{{/include_localization}}{{^include_localization}}return english;{{/include_localization}}
  }

  // Text Styles - Display
  static TextStyle displayLarge(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: h1,
        fontWeight: bold,
        height: 1.2,
      );

  static TextStyle displayMedium(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: h2,
        fontWeight: bold,
        height: 1.2,
      );

  static TextStyle displaySmall(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: h3,
        fontWeight: bold,
        height: 1.2,
      );

  // Text Styles - Headline
  static TextStyle headlineLarge(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: h3,
        fontWeight: semiBold,
        height: 1.3,
      );

  static TextStyle headlineMedium(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: h4,
        fontWeight: semiBold,
        height: 1.3,
      );

  static TextStyle headlineSmall(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: h5,
        fontWeight: semiBold,
        height: 1.3,
      );

  // Text Styles - Title
  static TextStyle titleLarge(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: h4,
        fontWeight: medium,
        height: 1.4,
      );

  static TextStyle titleMedium(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: h5,
        fontWeight: medium,
        height: 1.4,
      );

  static TextStyle titleSmall(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: h6,
        fontWeight: medium,
        height: 1.4,
      );

  // Text Styles - Body
  static TextStyle bodyLargeStyle(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: bodyLarge,
        fontWeight: regular,
        height: 1.5,
      );

  static TextStyle bodyMediumStyle(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: bodyMedium,
        fontWeight: regular,
        height: 1.5,
      );

  static TextStyle bodySmallStyle(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: bodySmall,
        fontWeight: regular,
        height: 1.5,
      );

  // Text Styles - Label
  static TextStyle labelLarge(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: bodyMedium,
        fontWeight: medium,
        height: 1.4,
      );

  static TextStyle labelMedium(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: bodySmall,
        fontWeight: medium,
        height: 1.4,
      );

  static TextStyle labelSmall(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: caption,
        fontWeight: medium,
        height: 1.4,
      );

  // Button Text Styles
  static TextStyle button(Locale locale) => TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: bodyMedium,
        fontWeight: semiBold,
        height: 1.2,
      );
}
