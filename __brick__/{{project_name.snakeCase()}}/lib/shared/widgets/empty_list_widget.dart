import 'package:easy_localization/easy_localization.dart';
import 'package:{{project_name.snakeCase()}}/shared/extensions/context_extension.dart';
import 'package:{{project_name.snakeCase()}}/shared/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyListWidget extends StatelessWidget {
  final String? title;

  const EmptyListWidget({super.key, this.title});

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
            // illustration/animation
            Container(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Lottie.asset('assets/lottie/empty.json', repeat: false),
              ),
            ),

            const SizedBox(height: 24),

            // title
            Text(
              title?.tr() ?? 'There is no items in this list!'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: AppFonts.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
