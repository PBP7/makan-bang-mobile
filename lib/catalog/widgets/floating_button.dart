import 'package:flutter/material.dart'; 
// Assuming you'll create this form page later
import 'package:makan_bang/catalog/screens/product_entryform.dart';

class ShopFloatingActionButton extends StatelessWidget {
  const ShopFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Navigate to the product entry form
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductEntryFormPage(),
          ),
        );
      },
      tooltip: 'Add Product',
      child: const Icon(Icons.add),
    );
  }
}