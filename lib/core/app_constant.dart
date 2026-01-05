class AppConstant {
  static const String notificationChannelId = 'channel_id';
  static const String notificationChannelName = 'channel_name';
  static const String notificationChannelDescription = 'channel_description';

  // Messages
  static const String permissionNeededTitle = 'Permiso necesario';
  static const String notificationPermissionMessage =
      'Para poder enviarte notificaciones, debes habilitar los permisos desde los ajustes del sistema';
  static const String cancelLabel = 'Cancelar';
  static const String goToSettingsLabel = 'Ir a ajustes';
  static const String notificationPermissionGranted =
      'Notification permission was granted';
  static const String alarmPermissionAndroidOnly =
      'Alarm permission is supported only in Android';
  static const String alarmPermissionGranted = 'Alarm permission was granted';
  static const String timeChose = 'chosen time:';

  // Android Intents
  static const String scheduleExactAlarmAction =
      'android.settings.REQUEST_SCHEDULE_EXACT_ALARM';

  // Labels de botones
  static const String requestNotificationLabel =
      'Request notification permission';
  static const String showManualNotificationLabel = 'Show manual notification';
  static const String requestAlarmLabel = 'Request alarm permission';
  static const String scheduleNotificationLabel = 'Schedule notification';

  // Durations
  static const Duration snackBarDuration = Duration(milliseconds: 1500);
}
