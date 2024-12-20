import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:makan_bang/meal_planning/models/meal_plan_model.dart';

class MealPlanService {
  final String baseUrl = 'http://127.0.0.1:8000/meal-plannning/get-meal-plan/';

  Future<MealPlan?> fetchMealPlan(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?user=$userId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        if (data.isNotEmpty) {
          return MealPlan.fromJson(data.first);
        }
      }
    } catch (e) {
      print('Error fetching meal plan: $e');
    }
    return null;
  }

  Future<bool> saveMealPlan(MealPlan mealPlan) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(mealPlan.toJson()),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error saving meal plan: $e');
    }
    return false;
  }

  static getFoodItems(List<int> foodIds) {}
}
