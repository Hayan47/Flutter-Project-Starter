import 'package:easy_localization/easy_localization.dart';
import 'package:{{project_name.snakeCase()}}/shared/extensions/context_extension.dart';
import 'package:{{project_name.snakeCase()}}/shared/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String content;
  final Widget action;

  const MyDialog({
    super.key,
    required this.title,
    required this.content,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title.tr(),
        style: Theme.of(context)
            .extension<AppTextTheme>()!
            .displaySmall!
            .copyWith(fontWeight: AppFonts.medium),
      ),
      content: Text(
        content.tr(),
        style: Theme.of(context).extension<AppTextTheme>()!.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Cancel'.tr(),
            style: Theme.of(context)
                .extension<AppTextTheme>()!
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        action,
      ],
    );
  }
}
