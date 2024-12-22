import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/meal_planning/screens/create_mealplan.dart';
import '../widgets/food_card.dart';

class FoodChoicesScreen extends StatefulWidget {
  const FoodChoicesScreen({super.key});

  @override
  _FoodChoicesScreenState createState() => _FoodChoicesScreenState();
}

class _FoodChoicesScreenState extends State<FoodChoicesScreen> {
  List<Product> foodItems = [];
  List<Product> selectedFoods = [];

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

  void toggleSelection(Product id) {
    setState(() {
      if (selectedFoods.contains(id)) {
        selectedFoods.remove(id);
      } else {
        selectedFoods.add(id);
      }
    });
  }

  void submitChoices() {
    Navigator.pop(context, selectedFoods);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2; // 3 per baris untuk tablet, 2 untuk HP

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Food'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: selectedFoods.isNotEmpty ? submitChoices : null,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit Choices',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: foodItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final food = foodItems[index].fields;
                return GestureDetector(
                  onTap: () => toggleSelection(foodItems[index]),
                  child: FoodCard(
                    food: food,
                    isSelected: selectedFoods.contains(foodItems[index]),
                    imageHeightFraction: 0.5, // Gambar 50% dari tinggi card
                    textStyle: const TextStyle(
                      fontSize: 12, // Ukuran teks disesuaikan
                      overflow: TextOverflow.ellipsis, // Potong teks jika panjang
                    ),
                  ),
                );
              },
            ),
    );
  }
}
