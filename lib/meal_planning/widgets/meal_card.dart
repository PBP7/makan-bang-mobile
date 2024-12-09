import 'package:flutter/material.dart';
import '../models/meal_plan_model.dart';

class MealCard extends StatelessWidget {
  final MealPlan mealPlan;
  final VoidCallback onExpand;
  final VoidCallback onDelete;

  const MealCard({
    Key? key,
    required this.mealPlan,
    required this.onExpand,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text('Meal Plan ID: ${mealPlan.pk}'),
            subtitle: Text('Date: ${mealPlan.fields.date.toLocal()} - Time: ${mealPlan.fields.time}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ),
          // Expandable food items list
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
