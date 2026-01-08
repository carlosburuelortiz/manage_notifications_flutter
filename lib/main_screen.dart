import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_notifications_flutter/core/app_constant.dart';
import 'package:manage_notifications_flutter/core/injection.dart';
import 'package:manage_notifications_flutter/core/snackbar_type_durations.dart';
import 'package:manage_notifications_flutter/core/ui_helpers.dart';
import 'package:manage_notifications_flutter/notification_service.dart';
import 'package:manage_notifications_flutter/presentation/mixin/time_picker_mixin.dart';
import 'package:manage_notifications_flutter/service/android_settings_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/blocs.dart';
import 'presentation/widget/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with WidgetsBindingObserver, TimePickerMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: _buildListeners(),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildActionButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    return [
      CustomButton(
        label: AppConstant.requestNotificationLabel,
        onPressed:
            () => context.read<PermissionBloc>().add(
              RequestNotificationPermission(),
            ),
        textColor: Colors.red,
      ),

      CustomButton(
        label: AppConstant.showManualNotificationLabel,
        onPressed: () => getIt<NotificationService>().showManualNotification(),
      ),

      CustomButton(
        label: AppConstant.requestAlarmLabel,
        onPressed:
            () => context.read<AlarmPermissionBloc>().add(
              RequestAlarmPermission(),
            ),
        textColor: Colors.red,
      ),

      CustomButton(
        label: AppConstant.scheduleNotificationLabel,
        onPressed: _scheduleNotification,
      ),
    ];
  }

  List<BlocListener> _buildListeners() {
    return [
      BlocListener<PermissionBloc, PermissionState>(
        listener: _handlePermissionState,
      ),
      BlocListener<AlarmPermissionBloc, AlarmPermissionState>(
        listener: _handleAlarmPermissionState,
      ),
      BlocListener<TimePickerBloc, TimePickerState>(
        listener: _handleTimePickerState,
      ),
    ];
  }

  void _handlePermissionState(BuildContext context, PermissionState state) {
    switch (state) {
      case PermissionGranted _:
        UIHelpers.showSnackBarMessage(
          context,
          AppConstant.notificationPermissionGranted,
        );
        break;
      case PermissionDenied _:
        UIHelpers.showSnackBarMessage(
          context,
          AppConstant.notificationPermissionDenied,
          SnackbarTypeDurations.medium,
        );
        break;
      case PermissionDeniedPermanently _:
        UIHelpers.showPermissionDialog(context, _goToNotificationSettings);
        break;
      case PermissionDeniedGoToSettings _:
        UIHelpers.showPermissionDialog(context, _goToNotificationIOSSettings);
        break;
      default:
        break;
    }

    // if (state is PermissionDeniedPermanently) {
    //   UIHelpers.showPermissionDialog(context, _goToNotificationSettings);
    // } else if (state is PermissionDenied) {
    //   UIHelpers.showSnackBarMessage(
    //     context,
    //     AppConstant.notificationPermissionDenied,
    //     SnackbarTypeDurations.medium,
    //   );
    // } else if (state is PermissionGranted) {
    //   UIHelpers.showSnackBarMessage(
    //     context,
    //     AppConstant.notificationPermissionGranted,
    //   );
    // } else if (state is PermissionDeniedGoToSettings) {
    //   UIHelpers.showPermissionDialog(context, _goToNotificationIOSSettings);
    // }
  }

  void _handleAlarmPermissionState(
    BuildContext context,
    AlarmPermissionState state,
  ) {
    if (state is AlarmPermissionDenied) {
      _requestScheduleExactAlarmActivity();
    } else if (state is AlarmPermissionIsNotAndroid) {
      UIHelpers.showSnackBarMessage(
        context,
        AppConstant.alarmPermissionAndroidOnly,
      );
    } else if (state is AlarmPermissionGranted) {
      UIHelpers.showSnackBarMessage(
        context,
        AppConstant.alarmPermissionGranted,
      );
    }
  }

  void _handleTimePickerState(BuildContext context, TimePickerState state) {
    if (state is TimePickerSelected) {
      UIHelpers.showSnackBarMessage(
        context,
        '${AppConstant.timeChose} ${state.timeOfDay.format(context)}',
      );
    }
  }

  Future<void> _scheduleNotification() async {
    final bloc = context.read<TimePickerBloc>();
    await selectTime(context);
    bloc.add(SelectTimeEvent(selectedTime));
  }

  Future<void> _goToNotificationSettings() async {
    Navigator.of(context).pop();
    await openAppSettings();
  }

  Future<void> _goToNotificationIOSSettings() async {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
    Navigator.of(context).pop();
  }

  Future<void> _requestScheduleExactAlarmActivity() async {
    await getIt<AndroidSettingsService>().openScheduleExactAlarmSettings();
  }
}
