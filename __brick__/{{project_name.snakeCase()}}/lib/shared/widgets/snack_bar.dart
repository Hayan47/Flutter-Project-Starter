import 'package:flutter/material.dart';

import '../../shared/extensions/context_extension.dart';
import '../../shared/theme/app_colors.dart';

enum SnackBarType { success, error, warning, info }

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    super.key,
    required this.title,
    required this.message,
    required this.type,
  });

  final String title;
  final String message;
  final SnackBarType type;

  static const double _borderRadius = 12.0;
  static const double _horizontalPadding = 12.0;
  static const double _verticalPadding = 10.0;
  static const double _iconSize = 22.0;
  static const double _iconInnerSize = 12.0;
  static const double _spacing = 10.0;
  static const double _smallSpacing = 6.0;
  static const double _tinySpacing = 2.0;
  static const double _closeIconSize = 14.0;
  static const double _borderWidth = 0.5;

  _SnackBarStyle get _style => switch (type) {
    SnackBarType.success => const _SnackBarStyle(
      background: AppColors.successBackground,
      border: AppColors.successBorder,
      iconBackground: AppColors.successIconBackground,
      textColor: AppColors.successText,
      icon: Icons.check_rounded,
    ),
    SnackBarType.error => const _SnackBarStyle(
      background: AppColors.errorBackground,
      border: AppColors.errorBorder,
      iconBackground: AppColors.errorIconBackground,
      textColor: AppColors.errorText,
      icon: Icons.priority_high_rounded,
    ),
    SnackBarType.warning => const _SnackBarStyle(
      background: AppColors.warningBackground,
      border: AppColors.warningBorder,
      iconBackground: AppColors.warningIconBackground,
      textColor: AppColors.warningText,
      icon: Icons.priority_high_rounded,
    ),
    SnackBarType.info => const _SnackBarStyle(
      background: AppColors.infoBackground,
      border: AppColors.infoBorder,
      iconBackground: AppColors.infoIconBackground,
      textColor: AppColors.infoText,
      icon: Icons.info_outline_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: style.border, width: _borderWidth),
      ),
      child: Row(
        children: [
          Container(
            width: _iconSize,
            height: _iconSize,
            decoration: BoxDecoration(
              color: style.iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              style.icon,
              color: AppColors.textOnPrimary,
              size: _iconInnerSize,
            ),
          ),
          const SizedBox(width: _spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: style.textColor,
                  ),
                ),
                const SizedBox(height: _tinySpacing),
                Text(
                  message,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: style.textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: _smallSpacing),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            child: Icon(
              Icons.close_rounded,
              size: _closeIconSize,
              color: style.textColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SnackBarStyle {
  const _SnackBarStyle({
    required this.background,
    required this.border,
    required this.iconBackground,
    required this.textColor,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color iconBackground;
  final Color textColor;
  final IconData icon;
}
