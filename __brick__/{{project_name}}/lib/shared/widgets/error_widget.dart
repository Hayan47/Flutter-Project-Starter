{{#include_localization}}import 'package:easy_localization/easy_localization.dart';
{{/include_localization}}import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/shared/theme/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/shared/theme/app_fonts.dart';

class AppErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final bool withActions;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.title,
    required this.message,
    this.withActions = true,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Error title
            Text(
              {{#include_localization}}title.tr(){{/include_localization}}{{^include_localization}}title{{/include_localization}},
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: AppFonts.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Error message
            Text(
              {{#include_localization}}message.tr(){{/include_localization}}{{^include_localization}}message{{/include_localization}},
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Actions
            if (withActions) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Retry button
                  if (onRetry != null)
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 20,
                        color: AppColors.textOnPrimary,
                      ),
                      label: Text({{#include_localization}}'try_again'.tr(){{/include_localization}}{{^include_localization}}'Try Again'{{/include_localization}}),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Go back option
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  {{#include_localization}}'go_back'.tr(){{/include_localization}}{{^include_localization}}'Go Back'{{/include_localization}},
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}