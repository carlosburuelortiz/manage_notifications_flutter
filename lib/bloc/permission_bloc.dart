import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_notifications_flutter/bloc/permission_event.dart';
import 'package:manage_notifications_flutter/bloc/permission_state.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionInitial()) {
    on<RequestNotificationPermission>((event, emit) async {
      final status = await Permission.notification.request();
      if (status == PermissionStatus.permanentlyDenied) {
        emit(PermissionDeniedPermanently());
      } else {
        emit(PermissionGranted());
      }
    });
  }
}
