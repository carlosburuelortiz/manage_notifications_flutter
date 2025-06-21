import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:manage_notifications_flutter/bloc/alarm/alarm_permission_event.dart';
import 'package:manage_notifications_flutter/bloc/alarm/alarm_permission_state.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissionBloc
    extends Bloc<AlarmPermissionEvent, AlarmPermissionState> {
  AlarmPermissionBloc() : super(AlarmPermissionInitial()) {
    on<RequestAlarmPermission>((event, emit) async {
      if (!Platform.isAndroid) {
        emit(AlarmPermissionIsNotAndroid());
      } else {
        if (await Permission.scheduleExactAlarm.status.isGranted) {
          emit(AlarmPermissionGranted());
        } else {
          emit(AlarmPermissionDenied());
        }
      }
    });
  }
}
