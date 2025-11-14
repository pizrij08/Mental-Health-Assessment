import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_mhproj/design_system/tokens/color_tokens.dart';
import 'package:flutter_application_mhproj/design_system/tokens/typography.dart';

import '../application/appointment_controller.dart';
import '../domain/appointment.dart';

class AddAppointmentPage extends ConsumerStatefulWidget {
  const AddAppointmentPage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  @override
  ConsumerState<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends ConsumerState<AddAppointmentPage> {
  late bool _isDarkMode;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  String _selectedMode = 'Online';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Appointment _buildAppointment() => Appointment(
        date: _selectedDate!,
        time: _selectedTime!,
        mode: _selectedMode,
        participant: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      );

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _saveAppointment() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time.')),
      );
      return;
    }
    ref.read(appointmentControllerProvider.notifier).add(_buildAppointment());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Appointment', style: MindWellTypography.sectionSubtitle(color: MindWellColors.darkGray).copyWith(fontSize: 20)),
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Enter your name',
                  labelText: 'Name *',
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  _selectedTime != null
                      ? 'Time: ${Appointment(date: DateTime.now(), time: _selectedTime!, mode: '').formattedTime}'
                      : 'Select Time',
                ),
                trailing: ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: const Text('Pick'),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _selectedDate != null
                      ? 'Date: ${Appointment(date: _selectedDate!, time: TimeOfDay.now(), mode: '').formattedDate}'
                      : 'Select Date',
                ),
                trailing: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Pick'),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Online'),
                      value: 'Online',
                      groupValue: _selectedMode,
                      onChanged: (value) => setState(() => _selectedMode = value ?? 'Online'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('In-Person'),
                      value: 'In-Person',
                      groupValue: _selectedMode,
                      onChanged: (value) => setState(() => _selectedMode = value ?? 'In-Person'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Save Appointment'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: MindWellColors.darkGray,
                  foregroundColor: MindWellColors.cream,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveAppointment();
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Your appointment will appear in the list on the previous screen.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
