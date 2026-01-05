import 'package:get_it/get_it.dart';

import 'package:manage_notifications_flutter/bloc/alarm/alarm_permission_bloc.dart';
import 'package:manage_notifications_flutter/bloc/permission_bloc.dart';
import 'package:manage_notifications_flutter/bloc/timePicker/time_picker_bloc.dart';
import 'package:manage_notifications_flutter/notification_scheduler_service.dart';
import 'package:manage_notifications_flutter/notification_service.dart';
import 'package:manage_notifications_flutter/service/android_settings_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton<NotificationSchedulerService>(
    () => NotificationSchedulerService(),
  );
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<AndroidSettingsService>(
    () => AndroidSettingsService(),
  );

  // Blocs
  sl.registerFactory(() => PermissionBloc());
  sl.registerFactory(() => AlarmPermissionBloc());
  sl.registerFactory(() => TimePickerBloc(/*NotificationService*/ sl()));
}
