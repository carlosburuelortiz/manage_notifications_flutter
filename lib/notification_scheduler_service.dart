import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manage_notifications_flutter/core/injection.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationSchedulerService {
  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Notifications',
      channelDescription: 'Notificaciones diarias a una hora especifica',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await sl<FlutterLocalNotificationsPlugin>().zonedSchedule(
      0, //ID
      'Recordatorio diario',
      'Notificacion con la hora elegida',
      _nextInstanceOfTime(hour, minute),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // daily repeat
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      0, // first second
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 1));
    }
    return scheduled;
  }
}
