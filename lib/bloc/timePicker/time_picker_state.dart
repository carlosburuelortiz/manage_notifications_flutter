import 'package:flutter/material.dart';

abstract class TimePickerState {}

class TimePickerInitial extends TimePickerState {}

class TimePickerSelected extends TimePickerState {
  final TimeOfDay timeOfDay;

  TimePickerSelected(this.timeOfDay);
}
