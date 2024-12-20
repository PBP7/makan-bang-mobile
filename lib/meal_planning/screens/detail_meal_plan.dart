import 'package:flutter/material.dart';
import 'package:makan_bang/meal_planning/models/meal_plan_model.dart';
import 'package:makan_bang/meal_planning/screens/create_mealplan.dart';
import 'package:makan_bang/meal_planning/screens/first_page_meal_plan.dart';
import 'package:makan_bang/meal_planning/services/meal_plan_service.dart';
import 'package:intl/intl.dart';

class MealPlanDetailScreen extends StatefulWidget {
  final MealPlan mealPlan;
  final Function refreshMealPlans;

  const MealPlanDetailScreen({
    Key? key,
    required this.mealPlan,
    required this.refreshMealPlans,
  }) : super(key: key);

  @override
  State<MealPlanDetailScreen> createState() => _MealPlanDetailScreenState();
}

class _MealPlanDetailScreenState extends State<MealPlanDetailScreen> {
  List<String> foodItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    try {
      final foodNames = widget.mealPlan.fields.foodItems
          .where((name) => name != null && name.isNotEmpty)
          .toList();
      setState(() {
        foodItems = foodNames;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading food items: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteMealPlan() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure to delete this meal plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirm
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await MealPlanService(baseUrl: 'http://127.0.0.1:8000/meal-planning/')
            .deleteMealPlan(widget.mealPlan.pk);
        if (mounted) {
          widget.refreshMealPlans();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meal plan deleted successfully')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MealPlanScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting meal plan: $e')),
          );
        }
      }
    }
  }

  void _editMealPlan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateMealPlanScreen(mealPlan: widget.mealPlan),
      ),
    ).then((_) => widget.refreshMealPlans());
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMMM, dd yyyy').format(widget.mealPlan.fields.date);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Your Meal Plan'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete'),
                          onPressed: _deleteMealPlan,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit'),
                          onPressed: _editMealPlan,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(formattedDate),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading: const Icon(Icons.access_time),
                          title: Text(
                              widget.mealPlan.fields.time ?? 'Not specified'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : foodItems.isEmpty
                    ? const Center(child: Text('No food items available'))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'These are your meals:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: foodItems.length,
                                itemBuilder: (context, index) {
                                  final foodName = foodItems[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      leading: const Icon(Icons.fastfood),
                                      title: Text(foodName),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
