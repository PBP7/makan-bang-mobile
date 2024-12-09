import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final VoidCallback onPickTime;

  const TimePickerWidget({
    Key? key,
    this.selectedTime,
    required this.onPickTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(Icons.access_time),
      label: Text(
        selectedTime == null
            ? 'Pick a Time'
            : 'Time: ${selectedTime!.format(context)}',
      ),
      onPressed: onPickTime,
    );
  }
}
