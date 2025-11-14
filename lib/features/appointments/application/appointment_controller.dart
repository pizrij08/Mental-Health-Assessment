import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/appointment.dart';

class AppointmentController extends StateNotifier<List<Appointment>> {
  AppointmentController()
      : super([
          Appointment(
            date: DateTime(2025, 8, 14),
            time: const TimeOfDay(hour: 10, minute: 0),
            mode: 'Online',
          ),
          Appointment(
            date: DateTime(2025, 8, 15),
            time: const TimeOfDay(hour: 14, minute: 30),
            mode: 'In-Person',
          ),
          Appointment(
            date: DateTime(2025, 8, 18),
            time: const TimeOfDay(hour: 9, minute: 0),
            mode: 'Online',
          ),
        ]);

  void add(Appointment appointment) {
    state = [...state, appointment];
  }
}

final appointmentControllerProvider =
    StateNotifierProvider<AppointmentController, List<Appointment>>((ref) => AppointmentController());
