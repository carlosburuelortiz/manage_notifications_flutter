import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manage_notifications_flutter/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import 'bloc/blocs.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool _shouldCheckAlarmPermission = false;
  bool _shouldCheckNotificationPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_shouldCheckAlarmPermission) {
        _shouldCheckAlarmPermission = false;
        context.read<AlarmPermissionBloc>().add(RequestAlarmPermission());
      }

      if (_shouldCheckNotificationPermission) {
        _shouldCheckNotificationPermission = false;
        context.read<PermissionBloc>().add(RequestNotificationPermission());
      }
    }
  }

  void showNotificationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Permiso necesario'),
            content: Text(
              'Para poder enviarte notificaciones, debes habilitar los persmisos desde los ajustes del sistema',
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  _shouldCheckNotificationPermission = true;
                  await openAppSettings();
                },
                child: const Text('Ir a ajustes'),
              ),
            ],
          ),
    );
  }

  void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification permission was granted'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
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

    await flutterLocalNotificationPlugin.zonedSchedule(
      0, //ID
      'Recordatorio diario',
      'Ya paso 1 minuto bastardo!',
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
      now.second,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 1));
    }
    return scheduled;
  }

  requestScheduleExactAlarmActivity() async {
    _shouldCheckAlarmPermission = true;
    final intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PermissionBloc, PermissionState>(
          listener: (context, state) {
            if (state is PermissionDeniedPermanently) {
              showNotificationPermissionDialog(context);
            } else {
              showSnackBarMessage(
                context,
                'Notification permission was granted',
              );
            }
          },
        ),
        BlocListener<AlarmPermissionBloc, AlarmPermissionState>(
          listener: (context, state) {
            if (state is AlarmPermissionDenied) {
              requestScheduleExactAlarmActivity();
            } else if (state is AlarmPermissionIsNotAndroid) {
              showSnackBarMessage(
                context,
                "Alarm permission is supported only in Android",
              );
            } else {
              showSnackBarMessage(context, 'Alarm permission was granted');
            }
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.read<PermissionBloc>().add(
                    RequestNotificationPermission(),
                  );
                },
                child: Text(
                  'Request notification permission',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  showNotification();
                },
                child: Text('Show manual notification'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AlarmPermissionBloc>().add(
                    RequestAlarmPermission(),
                  );
                },
                child: Text(
                  'Request alarm permission',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  scheduleDailyNotification(hour: 10, minute: 30);
                },
                child: Text('Schedule notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
