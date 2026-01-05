import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:manage_notifications_flutter/bloc/alarm/alarm_permission_event.dart';
import 'package:manage_notifications_flutter/bloc/alarm/alarm_permission_state.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissionBloc
    extends Bloc<AlarmPermissionEvent, AlarmPermissionState> {
  AlarmPermissionBloc() : super(AlarmPermissionInitial()) {
    on<RequestAlarmPermission>(_handlePermissionEvent);
  }

  Future<void> _handlePermissionEvent(
    AlarmPermissionEvent event,
    Emitter<AlarmPermissionState> emit,
  ) async {
    if (!Platform.isAndroid) {
      emit(AlarmPermissionIsNotAndroid());
    } else {
      final hasPermission =
          await Permission.scheduleExactAlarm.status.isGranted;
      if (hasPermission) {
        emit(AlarmPermissionGranted());
      } else {
        emit(AlarmPermissionDenied());
      }
    }
  }
}
