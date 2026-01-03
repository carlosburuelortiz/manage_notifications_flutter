import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:manage_notifications_flutter/bloc/timePicker/time_picker_state.dart';
import 'package:manage_notifications_flutter/bloc/timePicker/time_picker_event.dart';
import 'package:manage_notifications_flutter/notification_scheduler_service.dart';

class TimePickerBloc extends Bloc<TimePickerEvent, TimePickerState> {
  final NotificationSchedulerService _notificationScheduler;

  TimePickerBloc(this._notificationScheduler) : super(TimePickerInitial()) {
    on<SelectTimeEvent>((event, emit) async {
      final selectedTime = event.timeOfDay;
      final hour = selectedTime.hour;
      final minute = selectedTime.minute;
      await _notificationScheduler.scheduleDailyNotification(
        hour: hour,
        minute: minute,
      );

      emit(TimePickerSelected(event.timeOfDay));
    });
  }
}
