import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/catalog/screens/productdetail.dart';

class PreferenceProductCard extends StatelessWidget {
  final Product product;
  final double scaleFactor;

  const PreferenceProductCard({
    super.key,
    required this.product,
    this.scaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(4 * scaleFactor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16 * scaleFactor),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16 * scaleFactor),
                ),
                child: Image.network(
                  product.fields.pictureLink,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(8 * scaleFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.fields.item,
                      style: TextStyle(
                        fontSize: 13 * scaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4 * scaleFactor),
                    Text(
                      'Rp ${product.fields.price}',
                      style: TextStyle(
                        fontSize: 12 * scaleFactor,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4 * scaleFactor),
                    Row(
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 14 * scaleFactor,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4 * scaleFactor),
                        Expanded(
                          child: Text(
                            product.fields.restaurant,
                            style: TextStyle(
                              fontSize: 11 * scaleFactor,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 