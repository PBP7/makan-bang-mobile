import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final String? selectedDate;
  final VoidCallback onPickDate;

  const DatePickerWidget({
    Key? key,
    this.selectedDate,
    required this.onPickDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(Icons.calendar_today),
      label: Text(
        selectedDate == null || selectedDate!.isEmpty
            ? 'Pick a Date'
            : 'Date: $selectedDate',
      ),
      onPressed: onPickDate,
    );
  }
}
