import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manage_notifications_flutter/core/app_constant.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationPlugin;

  NotificationService(this._notificationPlugin);

  Future<void> showManualNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          AppConstant.notificationChannelId,
          AppConstant.notificationChannelName,
          channelDescription: AppConstant.notificationChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationPlugin.show(
      0, // Notification id
      'Hi!', // Title
      'This is a manual notification', // Body
      notificationDetails,
    );
  }
}
