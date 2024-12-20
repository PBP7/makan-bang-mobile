import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart' as catalog;
import 'package:makan_bang/meal_planning/screens/add_meal_plan.dart';
import 'package:makan_bang/meal_planning/screens/first_page_meal_plan.dart';
import 'package:makan_bang/meal_planning/screens/food_choices.dart';
import 'package:makan_bang/meal_planning/widgets/date_picker.dart';
import 'package:makan_bang/meal_planning/widgets/time_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/meal_plan_model.dart';

class CreateMealPlanScreen extends StatefulWidget {
  final MealPlan? mealPlan;

  const CreateMealPlanScreen({Key? key, this.mealPlan}) : super(key: key);

  @override
  _CreateMealPlanScreenState createState() => _CreateMealPlanScreenState();
}

class _CreateMealPlanScreenState extends State<CreateMealPlanScreen> {
  String? selectedDate;
  TimeOfDay? selectedTime;
  List<catalog.Product> foodItems = [];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.mealPlan != null) {
      _initializeForEditing();
    }
  }

  void _initializeForEditing() {
    isEditing = true;
    selectedDate = widget.mealPlan!.fields.date.toString();
    final timeParts = widget.mealPlan!.fields.time.split(':');
    selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
    _loadExistingFoodItems();
  }

  Future<void> _loadExistingFoodItems() async {
    try {
      final foodIds = widget.mealPlan!.fields.foodItems.map(int.parse).toList();
      final items = await MealPlanService.getFoodItems(foodIds);
      if (mounted) {
        setState(() {
          foodItems = items;
        });
      }
    } catch (e) {
      _showErrorSnackBar("Error loading food items: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _saveMealPlan(CookieRequest request) async {
    if (selectedDate == null || selectedTime == null || foodItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields before saving.")),
      );
      return;
    }

    // Format waktu dengan benar
    String formattedTime = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
    
    // Pastikan format tanggal YYYY-MM-DD
    DateTime parsedDate = DateTime.parse(selectedDate!);
    String formattedDate = "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";

    final encodedData = jsonEncode({
      'selected_date': formattedDate,
      'time': formattedTime,
      'foodItems': foodItems.map((item) => item.pk).toList(),
    });

    try {
      final endpoint = isEditing 
          ? 'http://127.0.0.1:8000/meal-planning/${widget.mealPlan!.pk}/update/'
          : 'http://127.0.0.1:8000/meal-planning/finish-json/';

      final response = await request.postJson(endpoint, encodedData);
      
      if (response['status'] == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEditing 
                ? "Meal Plan successfully updated!" 
                : "New Meal Plan successfully saved!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MealPlanScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response['message']}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate != null ? DateTime.parse(selectedDate!) : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Meal Plan' : 'Create Your Meal Plan'),
        actions: [
          TextButton(
            onPressed: () => _saveMealPlan(request),
            child: Text(
              isEditing ? "Update" : "Save",
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
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
                    child: _buildFoodItemsCard(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildDateTimePicker(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItemsCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
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
                ? _buildFoodItemsGrid()
                : const Center(child: Text("No food items added yet.")),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.add_circle, size: 48),
              color: Colors.blue,
              onPressed: () async {
                final selectedFoods = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodChoicesScreen()),
                );
                if (selectedFoods != null) {
                  setState(() {
                    foodItems.addAll(selectedFoods);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItemsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Card(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey[200],
                      child: Image.network(
                        foodItems[index].fields.pictureLink,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(foodItems[index].fields.item),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  setState(() {
                    foodItems.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateTimePicker() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Right Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
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
    );
  }
}
