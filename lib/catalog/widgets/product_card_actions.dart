import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/catalog/screens/product_entry_editform.dart'; // Pastikan path benar
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductCardActions extends StatelessWidget {
  final Product product;
  final VoidCallback onUpdateSuccess;

  const ProductCardActions({
    super.key,
    required this.product,
    required this.onUpdateSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate scaleFactor dengan batas maksimum
    double scaleFactor = (screenWidth / 1400).clamp(0.8, 12.0);

    // Responsive sizes untuk button
    double buttonHeight = 32 * scaleFactor;
    double buttonWidth = 80 * scaleFactor;
    double iconSize = 16 * scaleFactor;
    double fontSize = 12 * scaleFactor;

    // Padding yang responsif
    double horizontalPadding = 8 * scaleFactor;
    double verticalPadding = 4 * scaleFactor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Edit Button
        SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductEntryEditPage(
                    productData: {
                      'pk': product.pk,
                      'item': product.fields.item,
                      'picture_link': product.fields.pictureLink,
                      'description': product.fields.description,
                      'price': product.fields.price,
                      'kategori': product.fields.kategori,
                      'restaurant': product.fields.restaurant,
                      'lokasi': product.fields.lokasi,
                      'link_gofood': product.fields.linkGofood,
                      'nutrition': product.fields.nutrition,
                    },
                    product: product,
                  ),
                ),
              ).then((_) => onUpdateSuccess());
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white, // Fill color
              side: BorderSide(color: Colors.orange, width: 2), // Yellow border
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  size: iconSize,
                  color: Colors.orange, // Icon color
                ),
                SizedBox(width: 10 * scaleFactor),
                Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.orange, // Text color
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 8 * scaleFactor), // Spacing between buttons

        // Delete Button
        SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: OutlinedButton(
            onPressed: () async {
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Confirm Delete',
                    style: TextStyle(fontSize: 16 * scaleFactor),
                  ),
                  content: Text(
                    'Are you sure you want to delete ${product.fields.item}?',
                    style: TextStyle(fontSize: 14 * scaleFactor),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 14 * scaleFactor),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 14 * scaleFactor,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm) {
                try {
                  final response = await request.post(
                    'http://127.0.0.1:8000/katalog/delete-flutter/${product.pk}',
                    {},
                  );

                  if (context.mounted) {
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Product deleted successfully!"),
                        ),
                      );
                      onUpdateSuccess();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to delete product"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: ${e.toString()}"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white, // Fill color
              side: BorderSide(color: Colors.red, width: 2), // Red border
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  size: iconSize,
                  color: Colors.red, // Icon color
                ),
                SizedBox(width: 10 * scaleFactor),
                Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.red, // Text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
