import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerWidget({Key? key, required this.onTimeSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (selectedTime != null) {
          onTimeSelected(selectedTime);
        }
      },
      child: const Text('Select Time'),
    );
  }
}
