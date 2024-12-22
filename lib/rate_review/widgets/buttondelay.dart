import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/catalog/screens/product_entry_editform.dart'; // Pastikan path benar
import 'package:makan_bang/rate_review/models/ratereview_entry.dart';
import 'package:makan_bang/rate_review/screens/editreview.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewAction extends StatelessWidget {
  final RateReviewEntry rateReviewEntry;
  final VoidCallback onUpdateSuccess;

  const ReviewAction({
    super.key,
    required this.rateReviewEntry,
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
          child: ElevatedButton(
            onPressed: () {
              // Navigasi ke halaman form edit dan kirimkan produk yang akan diedit
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewEdit(          
                    productData: {
                      'pk' : rateReviewEntry.pk,
                      'user' : rateReviewEntry.fields.user,
                      'product' : rateReviewEntry.fields.product,
                      'rate' : rateReviewEntry.fields.rate,
                      'reviewText' : rateReviewEntry.fields.reviewText,
                      'date' : rateReviewEntry.fields.date
                    },
                    rateReviewEntry: rateReviewEntry
                  )

                ),
              ).then((_) => onUpdateSuccess());  // Update setelah kembali dari form
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
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
                ),
                SizedBox(width: 10 * scaleFactor),
                Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(width: 8 * scaleFactor), // Spacing antara button
        
        // Delete Button
        SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: ElevatedButton(
            onPressed: () async {
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Confirm Delete',
                    style: TextStyle(fontSize: 16 * scaleFactor),
                  ),
                  content: Text(
                    'Are you sure you want to delete comment by${rateReviewEntry.fields.user}?',
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
                    'https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/rate_review/delete-flutter/${rateReviewEntry.pk}',
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
                          content: Text("Failed to delete review"),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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
                ),
                SizedBox(width: 10 * scaleFactor),
                Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: fontSize,
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
