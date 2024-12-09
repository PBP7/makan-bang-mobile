import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatelessWidget {
  final Function(String) onDateSelected;

  const DatePickerWidget({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          onDateSelected(DateFormat('yyyy-MM-dd').format(selectedDate));
        }
      },
      child: const Text('Select Date'),
    );
  }
}
