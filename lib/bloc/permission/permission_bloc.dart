import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manage_notifications_flutter/bloc/permission/permission_event.dart';
import 'package:manage_notifications_flutter/bloc/permission/permission_state.dart';
import 'package:manage_notifications_flutter/core/injection.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionInitial()) {
    on<RequestNotificationPermission>((event, emit) async {
      if (Platform.isIOS) {
        final bool? result = await getIt<FlutterLocalNotificationsPlugin>()
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        if (result == true) {
          emit(PermissionGranted());
        } else {
          emit(PermissionDeniedGoToSettings());
        }
        return;
      } else {
        // Android flow
        final status = await Permission.notification.request();
        if (status == PermissionStatus.permanentlyDenied) {
          emit(PermissionDeniedPermanently());
        } else if (status == PermissionStatus.denied) {
          emit(PermissionDenied());
        } else {
          emit(PermissionGranted());
        }
      }
    });
  }
}
