import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makan_bang/meal_planning/screens/create_mealplan.dart';
import 'package:makan_bang/meal_planning/screens/detail_meal_plan.dart';
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
  String selectedFilter = 'all';

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
  
  // Future<void> _deleteMealPlan(int id) async {
  //   try {
  //     await mealPlanService.deleteMealPlan(id);
  //     _refreshMealPlans(); // Refresh the list after deletion
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Meal plan deleted successfully')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error deleting meal plan: $e')),
  //     );
  //   }
  // }

  // void _editMealPlan(MealPlan mealPlan) {
  //   // Navigate to edit screen
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CreateMealPlanScreen(mealPlan: mealPlan),
  //     ),
  //   ).then((_) => _refreshMealPlans()); // Refresh list when returning from edit screen
  // }

   List<MealPlan> _filterMealPlans(List<MealPlan> plans) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (selectedFilter) {
      case 'today':
        return plans.where((plan) {
          final planDate = DateTime(
            plan.fields.date.year,
            plan.fields.date.month,
            plan.fields.date.day,
          );
          return planDate.isAtSameMomentAs(today);
        }).toList();
      case 'past':
        return plans.where((plan) => plan.fields.date.isBefore(today)).toList();
      case 'future':
        return plans.where((plan) => plan.fields.date.isAfter(today)).toList();
      default:
        return plans;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
      ),
      drawer: LeftDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateMealPlanScreen()),
                ).then((_) => _refreshMealPlans());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Create a new one', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _filterButton('All Plan', 'all', Icons.calendar_today),
                _filterButton("Today's Plan", 'today', Icons.today),
                _filterButton("Future's Plan", 'future', Icons.update),
                _filterButton("Past's Plan", 'past', Icons.history),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Here's yours",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MealPlan>>(
              future: mealPlans,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No meal plans available'));
                }

                final filteredPlans = _filterMealPlans(snapshot.data!);
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredPlans.length,
                  itemBuilder: (context, index) {
                    final plan = filteredPlans[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        onTap: () {
                          // Handle card tap - show more details
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 52, 80, 172).withOpacity(0.2), // Warna lembut untuk latar belakang
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.set_meal, // Ikon piring yang lebih cocok
                                  size: 48,
                                  color: Color.fromARGB(78, 33, 10, 151),
                                ),
                              ),
                            ),
                           Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plan.fields.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Date: ${DateFormat('MMMM, dd yyyy').format(plan.fields.date)}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      'Time: ${plan.fields.time}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                         onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MealPlanDetailScreen(
                                                  mealPlan: plan,
                                                  refreshMealPlans: () => _refreshMealPlans(),
                                                ),
                                              ),
                                            );
                                          },
                                        child: const Text(
                                          'see more →',
                                          style: TextStyle(color: Colors.orange),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String label, String filter, IconData icon) {
    final isSelected = selectedFilter == filter;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedFilter = filter;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange[100] : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.orange : Colors.grey,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.orange : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}