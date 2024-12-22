import 'dart:convert';  // Untuk decoding JSON
import 'package:http/http.dart' as http;  // Untuk membuat HTTP request
import 'package:makan_bang/catalog/models/product_entry.dart';
import '../models/meal_plan_model.dart';  // Mengimpor model MealPlan

class MealPlanService {
  final String baseUrl;

  MealPlanService({required this.baseUrl});

  // Fetch meal plans dari server
  Future<List<MealPlan>> fetchMealPlans() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      // Pastikan data benar-benar valid
      if (responseData.isEmpty) {
        return [];
      }

      return responseData.map((item) => MealPlan.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meal plans');
    }
  }

   Future<void> deleteMealPlan(int id) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/meal-planning/$id/delete/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete meal plan');
    }
  }

  Future<void> updateMealPlan(int id, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/meal-planning/$id/update/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update meal plan');
    }
  }

  // in meal_plan_service.dart
// in meal_plan_service.dart
  // di meal_plan_service.dart
  Future<List<Product>> getFoodItems(List<String> foodItems) async {
    try {
      // Debug log
      // print("Sending request to get food items");
      // print("Food items to fetch: $foodItems");
      // print("URL: ${baseUrl}get-food-items/");

      // Pastikan ini benar-benar POST request
      final response = await http.post(
        Uri.parse('${baseUrl}get-food-items/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'food_ids': foodItems,
        }),
      );

      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load food items: ${response.body}');
      }
    } catch (e) {
      // print('Error in getFoodItems: $e');
      rethrow;
    }
  }
}

