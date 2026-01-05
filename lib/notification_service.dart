import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manage_notifications_flutter/core/app_constant.dart';
import 'timezone_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@drawable/ic_stat_name");

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationPlugin.initialize(initializationSettings);
  await initializeTimeZone(); // Important!
}

class NotificationService {
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

    await flutterLocalNotificationPlugin.show(
      0, // Notification id
      'Hi!', // Title
      'This is a manual notification', // Body
      notificationDetails,
    );
  }
}
