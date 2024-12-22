import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/catalog/screens/productdetail.dart';
import 'package:makan_bang/screens/login.dart';
import 'package:makan_bang/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late Future<List<Product>> _bookmarkedProductsFuture;

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _bookmarkedProductsFuture = fetchBookmarkedProducts(request);
  }

  Future<List<Product>> fetchBookmarkedProducts(CookieRequest request) async {
    final response = await request.get(
        'http://127.0.0.1:8000/bookmark/bookmarked-list/'); // Endpoint yang mengembalikan produk di-bookmark
    List<Product> productList = [];
    for (var d in response['products']) {
      productList.add(Product.fromJson(d));
    }
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    double width = MediaQuery.of(context).size.width;

    // Hitung scaleFactor berdasarkan ukuran layar
    double scaleFactor = getScaleFactor(width);

    // Tentukan jumlah kolom untuk GridView
    int crossAxisCount = width > 600 ? 3 : 2; // Mobile dan Tablet

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MAKAN BANG',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section with scaleFactor
          Padding(
            padding: EdgeInsets.fromLTRB(
              20 * scaleFactor,
              24 * scaleFactor,
              20 * scaleFactor,
              16 * scaleFactor
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Here's what you've bookmarked",
                  style: TextStyle(
                    fontSize: 24 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8 * scaleFactor),
                Text(
                  "List of your favorite food and beverages!",
                  style: TextStyle(
                    fontSize: 16 * scaleFactor,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Grid Content
          Expanded(
            child: FutureBuilder(
              future: _bookmarkedProductsFuture,
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border, 
                          size: 64 * scaleFactor, 
                          color: Colors.grey[400]
                        ),
                        SizedBox(height: 16 * scaleFactor),
                        Text(
                          'No bookmarked items yet',
                          style: TextStyle(
                            fontSize: 20 * scaleFactor,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8 * scaleFactor),
                        Text(
                          'Start exploring and save your favorites!',
                          style: TextStyle(
                            fontSize: 16 * scaleFactor,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return GridView.builder(
                    padding: EdgeInsets.all(16 * scaleFactor),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14 * scaleFactor,
                      mainAxisSpacing: 14 * scaleFactor,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      Product product = snapshot.data![index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12 * scaleFactor),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image Container with fixed height
                                SizedBox(
                                  height: 140 * scaleFactor, // Reduced height
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12 * scaleFactor)
                                    ),
                                    child: Image.network(
                                      product.fields.pictureLink,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Content Container
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10 * scaleFactor),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Category
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8 * scaleFactor,
                                            vertical: 4 * scaleFactor
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius: BorderRadius.circular(6 * scaleFactor),
                                          ),
                                          child: Text(
                                            product.fields.kategori,
                                            style: TextStyle(
                                              fontSize: 11 * scaleFactor, // Slightly reduced
                                              color: Colors.blue[900],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6 * scaleFactor),
                                        // Product Name
                                        Text(
                                          product.fields.item,
                                          style: TextStyle(
                                            fontSize: 14 * scaleFactor, // Slightly reduced
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4 * scaleFactor),
                                        // Price
                                        Text(
                                          'Rp${product.fields.price}',
                                          style: TextStyle(
                                            fontSize: 16 * scaleFactor,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[900],
                                          ),
                                        ),
                                        SizedBox(height: 4 * scaleFactor),
                                        // Restaurant
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.restaurant,
                                              size: 14 * scaleFactor,
                                              color: Colors.grey[600]
                                            ),
                                            SizedBox(width: 4 * scaleFactor),
                                            Expanded(
                                              child: Text(
                                                product.fields.restaurant,
                                                style: TextStyle(
                                                  fontSize: 12 * scaleFactor,
                                                  color: Colors.grey[600],
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
                            // Bookmark Button
                            Positioned(
                              top: 8 * scaleFactor,
                              right: 8 * scaleFactor,
                              child: Container(
                                padding: EdgeInsets.all(4 * scaleFactor),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20 * scaleFactor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4 * scaleFactor,
                                      spreadRadius: 1 * scaleFactor,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 18 * scaleFactor,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 30 * scaleFactor,
                                    minHeight: 30 * scaleFactor,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    try {
                                      final endpoint = 'http://127.0.0.1:8000/bookmark/toggle-bookmark-flutter/${product.pk}/';
                                      final response = await request.post(
                                        endpoint,
                                        jsonEncode({"product_id": product.pk}),
                                      );

                                      if (response['success'] == true) {
                                        setState(() {
                                          _bookmarkedProductsFuture = fetchBookmarkedProducts(request);
                                        });
                                      }
                                    } catch (e) {
                                      print("Error: $e");
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  double getScaleFactor(double width) {
    if (width <= 600) {
      return (width / 450).clamp(0.8, 1.2); // Mobile
    } else if (width <= 1024) {
      return (width / 800).clamp(0.6, 1.0); // Tablet
    } else {
      return (width / 1400).clamp(0.5, 0.8); // Desktop
    }
  }
}