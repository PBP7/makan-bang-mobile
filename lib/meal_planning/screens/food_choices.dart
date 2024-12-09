import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:makan_bang/catalog/models/product_entry.dart';
import '../widgets/food_card.dart';

class FoodChoicesScreen extends StatefulWidget {
  @override
  _FoodChoicesScreenState createState() => _FoodChoicesScreenState();
}

class _FoodChoicesScreenState extends State<FoodChoicesScreen> {
  List<Product> foodItems = [];
  List<String> selectedFoods = [];

  @override
  void initState() {
    super.initState();
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    final url = Uri.parse('http://127.0.0.1:8000/katalog/json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          foodItems = data.map((item) => Product.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load food items');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void toggleSelection(String id) {
    setState(() {
      if (selectedFoods.contains(id)) {
        selectedFoods.remove(id);
      } else {
        selectedFoods.add(id);
      }
    });
  }

  void submitChoices() {
    print("Selected Food IDs: $selectedFoods");
    // Lakukan pengiriman data atau navigasi ke halaman berikutnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Food'),
        actions: [
          TextButton(
            onPressed: submitChoices,
            child: const Text(
              'Submit Choices',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: foodItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final food = foodItems[index].fields;
                return GestureDetector(
                  onTap: () => toggleSelection(foodItems[index].pk),
                  child: FoodCard(
                    food: food,
                    isSelected: selectedFoods.contains(foodItems[index].pk),
                  ),
                );
              },
            ),
    );
  }
}
