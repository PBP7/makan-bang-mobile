import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';// Sesuaikan dengan path model Product
import '../widgets/navbar.dart';
import '../widgets/food_item_card.dart';
import '../widgets/date_picker.dart';
import '../widgets/time_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateMealPlanScreen extends StatefulWidget {
  const CreateMealPlanScreen({Key? key}) : super(key: key);

  @override
  _CreateMealPlanScreenState createState() => _CreateMealPlanScreenState();
}

class _CreateMealPlanScreenState extends State<CreateMealPlanScreen> {
  List<Product> foodItems = [];
  String? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    fetchFoodItems(); // Load data saat screen dimulai
  }

  Future<void> fetchFoodItems() async {
    final url = Uri.parse('http:localhost:8000/products/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          foodItems = productFromJson(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load food items')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(title: 'Create Your Meal Plan'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Food Added',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: foodItems.length,
                            itemBuilder: (context, index) {
                              final item = foodItems[index];
                              return FoodItemCard(
                                foodName: item.fields.item,
                                image: item.fields.pictureLink,
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: const Icon(Icons.add_circle, size: 50, color: Colors.red),
                            onPressed: () {
                              // Tambahkan logika untuk menambahkan makanan baru
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
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
                        const SizedBox(height: 10),
                        DatePickerWidget(onDateSelected: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        }),
                        const SizedBox(height: 16),
                        TimePickerWidget(onTimeSelected: (time) {
                          setState(() {
                            selectedTime = time;
                          });
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedDate == null || selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out the date and time')),
                  );
                  return;
                }

                // Logika untuk menyimpan meal plan
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
