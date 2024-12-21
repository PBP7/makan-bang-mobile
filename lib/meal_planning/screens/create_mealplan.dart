// Import yang relevan
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:makan_bang/catalog/models/product_entry.dart' as catalog;
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/meal_planning/screens/first_page_meal_plan.dart';
import 'package:makan_bang/meal_planning/screens/food_choices.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/meal_plan_model.dart';
import 'package:makan_bang/meal_planning/widgets/meal_plan_service.dart' as service;

class CreateMealPlanScreen extends StatefulWidget {
  final MealPlan? mealPlan;
  final String? initialTitle;
  final String? initialDate;
  final TimeOfDay? initialTime;
  final List<Product>? initialFoodItems;

  const CreateMealPlanScreen({
    super.key, 
    this.mealPlan,
    this.initialTitle,
    this.initialDate,
    this.initialTime,
    this.initialFoodItems,
  });

  @override
  _CreateMealPlanScreenState createState() => _CreateMealPlanScreenState();
}

class _CreateMealPlanScreenState extends State<CreateMealPlanScreen> {
  final TextEditingController _titleController = TextEditingController();
  final mealPlanService = service.MealPlanService(baseUrl: 'http://127.0.0.1:8000/meal-planning/json/');
  
  String? selectedDate;
  TimeOfDay? selectedTime;
  List<Product> foodItems = [];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.mealPlan != null) {
      _initializeForEditing();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _initializeForEditing() {
    isEditing = true;
    if (widget.initialTitle != null) _titleController.text = widget.initialTitle!;
    if (widget.initialDate != null) selectedDate = widget.initialDate;
    if (widget.initialTime != null) selectedTime = widget.initialTime;
    if (widget.initialFoodItems != null) {
      foodItems = List.from(widget.initialFoodItems!);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  Future<void> _saveMealPlan(CookieRequest request) async {
    if (_titleController.text.isEmpty || selectedDate == null || selectedTime == null || foodItems.isEmpty) {
      _showErrorSnackBar("Please complete all fields before saving.");
      return;
    }

    String formattedTime = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

    try {
      final endpoint = isEditing 
          ? 'http://127.0.0.1:8000/meal-planning/${widget.mealPlan!.pk}/update/'
          : 'http://127.0.0.1:8000/meal-planning/finish-json/';

      final response = await request.postJson(
        endpoint,
        jsonEncode({
          'title': _titleController.text,
          'selected_date': selectedDate,
          'time': formattedTime,
          'foodItems': foodItems.map((item) => item.pk).toList(),
        })
      );

      if (response['status'] == 'success') {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(isEditing ? "Meal Plan updated!" : "Meal Plan saved!")),
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MealPlanScreen()),
        );
      } else {
        _showErrorSnackBar("Error: ${response['message']}");
      }
    } catch (e) {
      // print("Error during save: $e");
      _showErrorSnackBar("Error: $e");
    }
  }

  void _pickDate() async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate != null 
        ? DateTime.parse(selectedDate!)
        : DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.black, // Header background color
            onPrimary: Colors.white, // Header text color
            onSurface: Colors.black, // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    setState(() {
      selectedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    });
  }
}


  void _pickTime() async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: selectedTime ?? TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.black, // Header background color
            onPrimary: Colors.white, // Header text color
            onSurface: Colors.black, // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
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
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        isEditing ? 'Edit Your Meal Plan' : 'Create Your Meal Plan',
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextField(
                  controller: _titleController,  // Ini akan otomatis terisi dari _initializeForEditing()
                  decoration: const InputDecoration(
                    hintText: "Write the title here",
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Date
                GestureDetector(
                  onTap: _pickDate,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color:Color.fromARGB(255, 0, 0, 0)),
                      const SizedBox(width: 12),
                      Text(
                        selectedDate != null 
                          ? DateFormat('MMMM, dd yyyy').format(DateTime.parse(selectedDate!))
                          : 'Choose the date',
                        style: const TextStyle(color: Color.fromARGB(255, 63, 62, 67)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Time
                GestureDetector(
                  onTap: _pickTime,
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Color.fromARGB(255, 0, 0, 0)),
                      const SizedBox(width: 12),
                      Text(
                        selectedTime != null 
                          ? selectedTime!.format(context)
                          : 'Choose the time',
                        style: const TextStyle(color: Color.fromARGB(255, 63, 62, 67)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Food Added Text
                // Food Added Section
const Text(
  'Food added:',
  style: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  ),
),
const SizedBox(height: 12),

// Food Items Container
Container(
  height: MediaQuery.of(context).size.height * 0.45, // Tinggi diatur 45% dari screen height
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Stack(
    children: [
      // Food Items List
      foodItems.isEmpty
        ? const Center(
            child: Text(
              'No food items added yet',
              style: TextStyle(color: Colors.grey),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final food = foodItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 60, // Card height diperkecil
                child: Row(
                  children: [
                    // Food Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        food.fields.pictureLink,
                        width: 45, // Image width diperkecil
                        height: 45, // Image height diperkecil
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Food Name
                    Expanded(
                      child: Text(
                        food.fields.item,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    // Remove Button
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      onPressed: () {
                        setState(() => foodItems.remove(food));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
      // Add Button
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, color: Colors.white, size: 20),
            onPressed: () async {
              final selectedFoods = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FoodChoicesScreen()),
              );
              if (selectedFoods != null) {
                setState(() {
                  foodItems.addAll(selectedFoods);
                });
              }
            },
          ),
        ),
      ),
    ],
  ),
),
const SizedBox(height: 16), // Spacing sebelum buttons
              ],
            ),
          ),
        ),
        // Bottom Buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _saveMealPlan(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}