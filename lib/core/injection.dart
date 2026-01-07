import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'timezone_helper.dart';

import 'package:manage_notifications_flutter/bloc/alarm/alarm_permission_bloc.dart';
import 'package:manage_notifications_flutter/bloc/permission/permission_bloc.dart';
import 'package:manage_notifications_flutter/bloc/timePicker/time_picker_bloc.dart';
import 'package:manage_notifications_flutter/notification_scheduler_service.dart';
import 'package:manage_notifications_flutter/notification_service.dart';
import 'package:manage_notifications_flutter/service/android_settings_service.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Register FlutterLocalNotificationsPlugin as singleton
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  await initializeNotifications();

  // Services
  sl.registerLazySingleton<NotificationSchedulerService>(
    () => NotificationSchedulerService(),
  );
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(sl<FlutterLocalNotificationsPlugin>()),
  );
  sl.registerLazySingleton<AndroidSettingsService>(
    () => AndroidSettingsService(),
  );

  // Blocs
  sl.registerFactory(() => PermissionBloc());
  sl.registerFactory(() => AlarmPermissionBloc());
  sl.registerFactory(() => TimePickerBloc(/*NotificationService*/ sl()));
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@drawable/ic_stat_name");

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await sl<FlutterLocalNotificationsPlugin>().initialize(
    initializationSettings,
  );
  await initializeTimeZone(); // Important!
}
