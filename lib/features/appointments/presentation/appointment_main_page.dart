import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_mhproj/design_system/tokens/color_tokens.dart';
import 'package:flutter_application_mhproj/design_system/tokens/typography.dart';

import '../application/appointment_controller.dart';
import '../domain/appointment.dart';
import 'add_appointment_page.dart';

class AppointmentMainPage extends ConsumerStatefulWidget {
  static const routeName = '/appointments';

  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const AppointmentMainPage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  ConsumerState<AppointmentMainPage> createState() => _AppointmentMainPageState();
}

class _AppointmentMainPageState extends ConsumerState<AppointmentMainPage> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  Future<void> _navigateToAddAppointment() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAppointmentPage(
          onThemeChanged: widget.onThemeChanged,
          isDarkMode: _isDarkMode,
        ),
      ),
    );
  }

  void _navigateToAppointmentDetail(Appointment appointment) {
    // 预留：可导航到预约详情页
  }

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(appointmentControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment'),
        centerTitle: true,
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              widget.onThemeChanged(value);
            },
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(_isDarkMode ? '☾' : '☀'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_box, size: 20),
                label: const Text("Add a New Appointment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MindWellColors.darkGray,
                  foregroundColor: MindWellColors.cream,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: _navigateToAddAppointment,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Current Appointments',
              style: MindWellTypography.sectionSubtitle(color: MindWellColors.darkGray).copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: appointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Icon(
                        appointment.mode == "Online" ? Icons.videocam : Icons.meeting_room,
                        color: MindWellColors.darkGray,
                      ),
                      title: Text(
                        "${appointment.formattedDate} at ${appointment.formattedTime}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(appointment.mode),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _navigateToAppointmentDetail(appointment),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
