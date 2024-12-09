import 'package:flutter/material.dart';
import 'package:makan_bang/meal_planning/screens/create_mealplan.dart';
import 'package:makan_bang/widgets/left_drawer.dart';
import '../models/meal_plan_model.dart';
import 'package:makan_bang/meal_planning/services/meal_plan_service.dart' as service;
import '../widgets/meal_card.dart';

class MealPlanScreen extends StatefulWidget {
  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  late Future<List<MealPlan>> mealPlans;
  final mealPlanService = service.MealPlanService(baseUrl: 'http://127.0.0.1:8000/meal-planning/json/');  // Updated API endpoint

  @override
  void initState() {
    super.initState();
    // Load the meal plans when the screen is initialized
    mealPlans = mealPlanService.fetchMealPlans();
  }

  void deleteMealPlan(int id) {
    // Delete the meal plan by id and update the UI
    mealPlanService.deleteMealPlan(id).then((_) {
      setState(() {
        mealPlans = mealPlanService.fetchMealPlans();  // Reload the meal plans
      });
    }).catchError((error) {
      // Show an error message if the deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete meal plan')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meal Plans')),
      drawer: LeftDrawer(),  // Use the LeftDrawer here
      body: FutureBuilder<List<MealPlan>>(
        future: mealPlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No meal plans available'));
          } else {
            return ListView(
              children: snapshot.data!
                  .map((plan) => MealCard(
                        mealPlan: plan,
                        onExpand: () {},  // You can add the expand functionality here if needed
                        onDelete: () => deleteMealPlan(plan.pk),  // Pass the delete function
                      ))
                  .toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman CreateMealPlanScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateMealPlanScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Create Meal Plan',
      ),
    );
  }
}
