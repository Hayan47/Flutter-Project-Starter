{{#include_localization}}import 'package:easy_localization/easy_localization.dart';
{{/include_localization}}import 'package:{{project_name.snakeCase()}}/shared/extensions/context_extension.dart';
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
        {{#include_localization}}
        title.tr()
        {{/include_localization}}
        {{^include_localization}}
        title
        {{/include_localization}},
        style: context.textTheme
            .displaySmall!
            .copyWith(fontWeight: AppFonts.medium),
      ),
      content: Text(
        {{#include_localization}}
        content.tr()
        {{/include_localization}}
        {{^include_localization}}
        content
        {{/include_localization}}, 
        style: context.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
          {{#include_localization}}
          'Cancel'.tr()
          {{/include_localization}}
          {{^include_localization}}
          'Cancel'
          {{/include_localization}},
            style: context.textTheme
                .bodyMedium!
                .copyWith(color: context.colorScheme.primary),
          ),
        ),
        action,
      ],
    );
  }
}
