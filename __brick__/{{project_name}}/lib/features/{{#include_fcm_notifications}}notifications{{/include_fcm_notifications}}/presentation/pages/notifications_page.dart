import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/shared/widgets/error_widget.dart';

import '../../../../../shared/widgets/empty_list_widget.dart';
import '../bloc/notification_bloc/notification_bloc.dart';
import '../widgets/notification_card_widget.dart';
import '../widgets/shimmer_notifications_page.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'.tr())),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return ShimmerNotificationsList(childrenCount: 8);
          }

          if (state is NotificationError) {
            return AppErrorWidget(
              title: 'No notifications found',
              message: state.message,
              withActions: true,
              onRetry:
                  () =>
                      context.read<NotificationBloc>().add(LoadNotifications()),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return EmptyListWidget(title: "No notifications yet!");
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(RefreshNotifications());
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 200) {
                    context.read<NotificationBloc>().add(
                      LoadMoreNotificationsEvent(),
                    );
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount:
                      state.notifications.length +
                      (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index < state.notifications.length) {
                      final notification = state.notifications[index];
                      return NotificationCardWidget(notification: notification);
                    } else {
                      if (state.isLoadingMore) {
                        return Center(
                          child: ShimmerNotificationsList(childrenCount: 1),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
