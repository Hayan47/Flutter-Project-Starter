import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/entities/notification.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:{{project_name.snakeCase()}}/shared/extensions/context_extension.dart';

import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_fonts.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color:
            notification.isRead
                ? Theme.of(context).colorScheme.surface
                : Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(2),
        // border: Border.all(
        //   color: AppColors.neutralGrey.withValues(alpha: 0.5),
        //   width: 1,
        // ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              context.read<NotificationBloc>().add(
                MarkNotificationAsRead(notification.id),
              );
            }
          },
          borderRadius: BorderRadius.circular(2),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon based on notification type
                SizedBox(
                  width: 53,
                  height: 53,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.8),
                        child: Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message
                      Text(
                        notification.message,
                        style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight:
                              notification.isRead
                                  ? AppFonts.medium
                                  : AppFonts.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Time
                      Text(
                        DateFormat.yMMMMd(
                          context.locale.toString(),
                        ).add_jm().format(notification.createdAt),
                        style: context.textTheme.bodySmall!.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight:
                              notification.isRead
                                  ? AppFonts.medium
                                  : AppFonts.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Unread indicator
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
