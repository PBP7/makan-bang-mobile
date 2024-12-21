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
        title: const Text('Bookmarked Products'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: _bookmarkedProductsFuture,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Anda belum memiliki produk yang di-bookmark.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 14 * scaleFactor,
                mainAxisSpacing: 14 * scaleFactor,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Product product = snapshot.data![index];
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double itemWidth = constraints.maxWidth;
                    double imageHeight = itemWidth * 0.5;
                    double fontSize = itemWidth * 0.06;

                    return Card(
                      elevation: 8,
                      margin: EdgeInsets.all(10 * scaleFactor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16 * scaleFactor),
                      ),
                      child: Stack(
                        children: [
                          InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              if (!request.loggedIn) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginPage()),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(product: product),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(16 * scaleFactor),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Gambar Produk
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16 * scaleFactor),
                                    ),
                                    child: product.fields.pictureLink.isNotEmpty
                                        ? Image.network(
                                            product.fields.pictureLink,
                                            height: imageHeight,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Image(
                                            image: const AssetImage(
                                                'assets/placeholder.jpg'),
                                            height: imageHeight,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.all(10 * scaleFactor),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Nama Produk
                                        Text(
                                          product.fields.item,
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8 * scaleFactor),
                                        // Harga Produk
                                        Text(
                                          'Price: \Rp${product.fields.price}',
                                          style: TextStyle(
                                            fontSize: fontSize * 1.2,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Top-Right Button
                          Positioned(
                            top: 8 * scaleFactor,
                            right: 8 * scaleFactor,
                            child: SizedBox(
                              height: 32 * scaleFactor,
                              width: 32 * scaleFactor,
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  try {
                                    final endpoint =
                                        'http://127.0.0.1:8000/bookmark/toggle-bookmark-flutter/${product.pk}/';
                                    final response = await request.post(
                                      endpoint,
                                      jsonEncode(
                                          {"product_id": product.pk}),
                                    );

                                    if (response['success'] == true) {
                                      setState(() {
                                        _bookmarkedProductsFuture =
                                            fetchBookmarkedProducts(
                                                request);
                                      });
                                    } else {
                                      throw Exception(
                                          "Failed to toggle bookmark: ${response['message']}");
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
              },
            );
          }
        },
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
