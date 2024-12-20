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


  // Fetch nama-nama makanan berdasarkan UUID
  Future<Map<String, String>> fetchFoodNames(List<String> foodIds) async {
    final foodNames = <String, String>{};

    for (var foodId in foodIds) {
      final response = await http.get(Uri.parse('$baseUrl/food-items/$foodId/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        foodNames[foodId] = data['name'];  // Ambil nama dari response
      } else {
        foodNames[foodId] = 'Makanan Tidak Dikenal';  // Default jika makanan tidak ditemukan
      }
    }

    return foodNames;
  }

  Future<List<Product>> getFoodItemsByName(List<String> names) async {
    try {
      final responses = await Future.wait(
        names.map((name) async {
          final response = await http.get(Uri.parse('localhost:8000/meal-planning/food-items-by-name/'));
          if (response.statusCode == 200) {
            return Product.fromJson(jsonDecode(response.body));
          } else {
            throw Exception('Failed to fetch food item for name: $name');
          }
        }),
      );

      return responses.cast<Product>();
    } catch (e) {
      throw Exception('Error fetching food items by name: $e');
    }
  }


  // Mengambil meal plans dengan nama makanan yang sudah diresolusikan
  Future<List<MealPlan>> fetchMealPlansWithNames() async {
    final mealPlans = await fetchMealPlans();

    // Resolve nama makanan untuk setiap meal plan
    for (var plan in mealPlans) {
      final foodNames = await fetchFoodNames(plan.fields.foodItems);

      // Ganti UUID dengan nama makanan dalam meal plan
      plan.fields.foodItems = plan.fields.foodItems
          .map((id) => foodNames[id] ?? "Makanan Tidak Dikenal")
          .toList();
    }

    return mealPlans;
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

  Future<List<Product>> getFoodItems(List<String> foodIds) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get-food-items/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'food_ids': foodIds}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load food items');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

