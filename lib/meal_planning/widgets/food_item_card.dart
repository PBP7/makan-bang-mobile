import 'package:flutter/material.dart';

class FoodItemCard extends StatelessWidget {
  final String foodName;
  final String? image;

  const FoodItemCard({
    super.key,
    required this.foodName,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: image != null
            ? Image.network(image!, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.image_not_supported),
        title: Text(foodName),
      ),
    );
  }
}
