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

   void _refreshMealPlans() {
    setState(() {
      mealPlans = mealPlanService.fetchMealPlans();
    });
  }
  
  Future<void> _deleteMealPlan(int id) async {
    try {
      await mealPlanService.deleteMealPlan(id);
      _refreshMealPlans(); // Refresh the list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal plan deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting meal plan: $e')),
      );
    }
  }

  void _editMealPlan(MealPlan mealPlan) {
    // Navigate to edit screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateMealPlanScreen(mealPlan: mealPlan),
      ),
    ).then((_) => _refreshMealPlans()); // Refresh list when returning from edit screen
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
                        onExpand: () {},
                        onDelete: () => _deleteMealPlan(plan.pk),
                        onEdit: () => _editMealPlan(plan),
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
          ).then((_) => _refreshMealPlans());
        },
        child: Icon(Icons.add),
        tooltip: 'Create Meal Plan',
      ),
    );
  }
}
