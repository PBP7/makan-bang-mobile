import 'dart:convert';

List<MealPlan> mealPlanFromJson(String str) => List<MealPlan>.from(json.decode(str).map((x) => MealPlan.fromJson(x)));

String mealPlanToJson(List<MealPlan> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class MealPlan {
  String model;
  int pk;
  Fields fields;

  MealPlan({
    required this.model,
    required this.pk,
    required this.fields,
  });

  // Factory untuk membuat MealPlan dari JSON
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    if (json["pk"] == null || json["fields"] == null) {
      throw Exception("Invalid data structure");
    }

    return MealPlan(
      model: json["model"] ?? "unknown",
      pk: json["pk"],
      fields: Fields.fromJson(json["fields"]),
    );
  }

  // Convert MealPlan ke JSON
  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  DateTime date;
  String time;
  List<String> foodItems;

  Fields({
    required this.user,
    required this.date,
    required this.time,
    required this.foodItems,
  });

  // Factory untuk membuat Fields dari JSON
  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        foodItems: List<String>.from(json["food_items"].map((x) => x)),
      );

  // Convert Fields ke JSON
  Map<String, dynamic> toJson() => {
        "user": user,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "food_items": List<dynamic>.from(foodItems.map((x) => x)),
      };
}
