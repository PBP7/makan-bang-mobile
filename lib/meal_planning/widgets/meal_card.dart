// meal_card.dart
import 'package:flutter/material.dart';
import '../models/meal_plan_model.dart';
import 'meal_plan_service.dart';

class MealCard extends StatelessWidget {
  final MealPlan mealPlan;
  final VoidCallback onExpand;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const MealCard({
    super.key,
    required this.mealPlan,
    required this.onExpand,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text('Meal Plan ID: ${mealPlan.pk}'),
            subtitle: Text(
                'Date: ${mealPlan.fields.date.toLocal()} - Time: ${mealPlan.fields.time}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Show confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Meal Plan'),
                          content: const Text(
                              'Are you sure you want to delete this meal plan?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                onDelete();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          if (mealPlan.fields.foodItems.isNotEmpty) ...[
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mealPlan.fields.foodItems.length,
              itemBuilder: (context, index) {
                final foodItem = mealPlan.fields.foodItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text('• $foodItem'),
                );
              },
            ),
          ],
          TextButton(
            onPressed: onExpand,
            child: const Text('Expand'),
          ),
        ],
      ),
    );
  }
}