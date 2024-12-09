import 'dart:convert';  // Untuk decoding JSON
import 'package:http/http.dart' as http;  // Untuk membuat HTTP request
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

  // Menghapus meal plan berdasarkan ID
  Future<void> deleteMealPlan(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id/'));  // Endpoint untuk menghapus berdasarkan id

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus meal plan');
    }
  }
}
