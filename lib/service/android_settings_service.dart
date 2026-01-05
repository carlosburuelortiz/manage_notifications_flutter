import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

import 'package:manage_notifications_flutter/core/app_constant.dart';

class AndroidSettingsService {
  Future<void> openScheduleExactAlarmSettings() async {
    final intent = AndroidIntent(
      action: AppConstant.scheduleExactAlarmAction,
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }
}
