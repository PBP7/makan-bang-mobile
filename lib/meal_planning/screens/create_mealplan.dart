import 'package:flutter/material.dart';
import 'package:makan_bang/meal_planning/widgets/date_picker.dart';
import 'package:makan_bang/meal_planning/widgets/time_picker.dart';

class CreateMealPlanScreen extends StatefulWidget {
  @override
  _CreateMealPlanScreenState createState() => _CreateMealPlanScreenState();
}

class _CreateMealPlanScreenState extends State<CreateMealPlanScreen> {
  String? selectedDate;
  TimeOfDay? selectedTime;
  List<String> foodItems = [];

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _saveMealPlan() {
    if (selectedDate == null || selectedTime == null || foodItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all fields before saving.")),
      );
      return;
    }
    // Perform save operation
    print("Meal Plan Saved with Date: $selectedDate, Time: ${selectedTime!.format(context)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Meal Plan'),
        actions: [
          TextButton(
            onPressed: _saveMealPlan,
            child: Text("Save", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Food Added',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Expanded(
                            child: foodItems.isNotEmpty
                                ? GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                    ),
                                    itemCount: foodItems.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.grey[200],
                                                child: Icon(Icons.fastfood),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(foodItems[index]),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Center(child: Text("No food items added yet.")),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(Icons.add_circle, size: 48),
                              color: Colors.blue,
                              onPressed: () {
                                // Add food selection logic here
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Your Right Time',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 16),
                            DatePickerWidget(
                              selectedDate: selectedDate,
                              onPickDate: _pickDate,
                            ),
                            TimePickerWidget(
                              selectedTime: selectedTime,
                              onPickTime: _pickTime,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
