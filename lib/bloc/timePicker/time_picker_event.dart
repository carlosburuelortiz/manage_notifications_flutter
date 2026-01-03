import 'package:flutter/material.dart';

abstract class TimePickerEvent {}

class SelectTimeEvent extends TimePickerEvent {
  final TimeOfDay timeOfDay;

  SelectTimeEvent(this.timeOfDay);
}
