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
      Uri.parse('https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/meal-planning/$id/delete/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete meal plan');
    }
  }

  Future<void> updateMealPlan(int id, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/meal-planning/$id/update/'),
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
      print("Sending food items (UUIDs): $foodItems"); // Debug log

      // Buat URL object
      var url = Uri.parse('https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/meal-planning/get-food-items/');
      
      // Buat request body dengan UUID
      var requestBody = jsonEncode({
        'food_ids': foodItems,  // List of UUIDs
      });

      print("Sending POST request to: $url");
      print("With body: $requestBody");

      final response = await http.post(
        url,
        headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
        },
        body: requestBody,
      );

      print("Request completed");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        print("Error response received");
        throw Exception('Failed to load food items. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error in getFoodItems: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

