import 'package:flutter/material.dart';

class Appointment {
  const Appointment({required this.date, required this.time, required this.mode, this.participant});

  final DateTime date;
  final TimeOfDay time;
  final String mode;
  final String? participant;

  Appointment copyWith({DateTime? date, TimeOfDay? time, String? mode, String? participant}) => Appointment(
        date: date ?? this.date,
        time: time ?? this.time,
        mode: mode ?? this.mode,
        participant: participant ?? this.participant,
      );

  String get formattedDate => '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

  String get formattedTime {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
