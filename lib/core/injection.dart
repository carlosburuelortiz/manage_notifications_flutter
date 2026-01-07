import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'timezone_helper.dart';

import 'package:manage_notifications_flutter/bloc/alarm/alarm_permission_bloc.dart';
import 'package:manage_notifications_flutter/bloc/permission/permission_bloc.dart';
import 'package:manage_notifications_flutter/bloc/timePicker/time_picker_bloc.dart';
import 'package:manage_notifications_flutter/notification_scheduler_service.dart';
import 'package:manage_notifications_flutter/notification_service.dart';
import 'package:manage_notifications_flutter/service/android_settings_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Register FlutterLocalNotificationsPlugin as singleton
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  await initializeNotifications();

  // Services
  getIt.registerLazySingleton<NotificationSchedulerService>(
    () => NotificationSchedulerService(),
  );
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(getIt<FlutterLocalNotificationsPlugin>()),
  );
  getIt.registerLazySingleton<AndroidSettingsService>(
    () => AndroidSettingsService(),
  );

  // Blocs
  getIt.registerFactory(() => PermissionBloc());
  getIt.registerFactory(() => AlarmPermissionBloc());
  getIt.registerFactory(() => TimePickerBloc(/*NotificationService*/ getIt()));
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

  await getIt<FlutterLocalNotificationsPlugin>().initialize(
    initializationSettings,
  );
  await initializeTimeZone(); // Important!
}
