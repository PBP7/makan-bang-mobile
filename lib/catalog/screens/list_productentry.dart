import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart'; // Model yang sudah diperbarui
import 'package:makan_bang/catalog/screens/productdetail.dart';
import 'package:makan_bang/catalog/widgets/product_card_actions.dart';
import 'package:makan_bang/models/user.dart.dart';
import 'package:makan_bang/screens/login.dart';
import 'package:makan_bang/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:makan_bang/catalog/widgets/floating_button.dart';

// Fungsi untuk menghitung scaleFactor berdasarkan ukuran layar

class ProductEntryPage extends StatefulWidget {
  const ProductEntryPage({super.key});

  @override
  State<ProductEntryPage> createState() => _ProductEntryPageState();
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

class _ProductEntryPageState extends State<ProductEntryPage> {
  late Future<List<Product>> _productFuture;

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _productFuture = fetchProducts(request); // Initialize Future here
  }

  Future<List<Product>> fetchProducts(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/katalog/json/');
    List<Product> productList = [];
    for (var d in response) {
      if (d != null) {
        productList.add(Product.fromJson(d));
      }
    }
    return productList;
  }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = context.watch<UserModel>();
    // MediaQuery untuk mendapatkan dimensi layar
    double width = MediaQuery.of(context).size.width;

    // Hitung scaleFactor berdasarkan ukuran layar
    double scaleFactor = getScaleFactor(width);

    // Tentukan jumlah kolom untuk GridView
    int crossAxisCount = width > 600 ? 3 : 2; // Mobile dan Tablet

    // Tentukan batas maksimal lebar untuk item agar tidak terlalu besar
    double maxWidth = width > 1000
        ? 1000
        : width; // Maksimal lebar 1000px untuk perangkat besar

    // Tentukan ukuran maksimal untuk gambar, font, dan elemen lainnya
    double maxImageHeight = 180; // Batas maksimal tinggi gambar
    double maxFontSize = 18; // Batas maksimal ukuran font

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
        floatingActionButton: user.name ==
                'admin' // Cek apakah user adalah admin
            ? const ShopFloatingActionButton() // Tampilkan FAB hanya untuk admin
            : null,
        body: FutureBuilder(
            future: _productFuture,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada data produk pada Toko Musik John Lennon.',
                      style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                    ),
                  );
                } else {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing:
                            14 * scaleFactor, // Sesuaikan spacing lebih kecil
                        mainAxisSpacing:
                            14 * scaleFactor, // Sesuaikan spacing lebih kecil
                        childAspectRatio:
                            0.7, // Rasio anak grid agar tidak terlalu tinggi
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        Product product = snapshot.data[index];
                        return LayoutBuilder(builder: (context, constraints) {
                          // Batasi ukuran lebar item untuk mencegah overflow pada layar besar
                          double itemWidth = constraints.maxWidth > maxWidth
                              ? maxWidth
                              : constraints.maxWidth;

                          // Ukuran gambar berdasarkan lebar item
                          double imageHeight =
                              itemWidth * 0.5; // Ukuran gambar lebih besar
                          if (imageHeight > maxImageHeight) {
                            imageHeight =
                                maxImageHeight; // Batasi tinggi gambar
                          }

                          // Ukuran font berdasarkan lebar item
                          double fontSize = itemWidth *
                              0.06; // Sedikit lebih besar dari sebelumnya
                          if (fontSize > maxFontSize) {
                            fontSize = maxFontSize; // Batasi
                          }

                          // Ukuran harga lebih besar
                          double priceFontSize = fontSize *
                              1.2; // Harga lebih besar dari nama produk

                          // Mengurangi ukuran kotak kategori
                          double categoryFontSize =
                              fontSize * 0.75; // Kecilkan ukuran font kategori
                          double categoryPadding =
                              4 * scaleFactor; // Padding kategori lebih kecil

                          return Card(
                            elevation: 4, // Reduced elevation for softer shadow
                            margin: EdgeInsets.all(8 * scaleFactor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12 * scaleFactor),
                            ),
                            child: Stack(
                              children: [
                                InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    if (!request.loggedIn) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoginPage()),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailPage(product: product),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12 * scaleFactor),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Image Section
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12 * scaleFactor),
                                          ),
                                          child: product.fields.pictureLink.isNotEmpty
                                              ? Image.network(
                                                  product.fields.pictureLink,
                                                  height: imageHeight,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'assets/placeholder.jpg',
                                                  height: imageHeight,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        // Content Section
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(12 * scaleFactor),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Category Tag
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8 * scaleFactor,
                                                    vertical: 4 * scaleFactor,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[50],
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    product.fields.kategori,
                                                    style: TextStyle(
                                                      fontSize: categoryFontSize,
                                                      color: Colors.blue[900],
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8 * scaleFactor),
                                                // Product Name
                                                Text(
                                                  product.fields.item,
                                                  style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4 * scaleFactor),
                                                // Price
                                                Text(
                                                  'Rp${product.fields.price}',
                                                  style: TextStyle(
                                                    fontSize: priceFontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green[900],
                                                  ),
                                                ),
                                                SizedBox(height: 8 * scaleFactor),
                                                // Restaurant info
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.restaurant,
                                                      size: 16 * scaleFactor,
                                                      color: Colors.grey[600],
                                                    ),
                                                    SizedBox(width: 4 * scaleFactor),
                                                    Expanded(
                                                      child: Text(
                                                        product.fields.restaurant,
                                                        style: TextStyle(
                                                          fontSize: fontSize * 0.8,
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
                                        // Admin Actions Section
                                        if (user.name == 'admin')
                                          Padding(
                                            padding: EdgeInsets.all(12 * scaleFactor),
                                            child: ProductCardActions(
                                              product: product,
                                              onUpdateSuccess: () {
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Favorite Button
                                Positioned(
                                  top: 8 * scaleFactor,
                                  right: 8 * scaleFactor,
                                  child: Container(
                                    padding: EdgeInsets.all(4 * scaleFactor),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return IconButton(
                                          icon: Icon(
                                            product.fields.bookmarked.contains(user.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: product.fields.bookmarked.contains(user.id)
                                                ? Colors.red
                                                : Colors.grey[400],
                                            size: 20 * scaleFactor,
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 32 * scaleFactor,
                                            minHeight: 32 * scaleFactor,
                                          ),
                                          padding: EdgeInsets.zero,
                                          onPressed: () async {
                                            // Bookmark logic remains the same
                                            final userId = user.id;
                                            try {
                                              final endpoint = 'http://127.0.0.1:8000/bookmark/toggle-bookmark-flutter/${product.pk}/';
                                              final response = await request.post(
                                                endpoint,
                                                jsonEncode({"product_id": product.pk}),
                                              );
                                              if (response['success'] == true) {
                                                setState(() {
                                                  if (response['bookmarked'] == true) {
                                                    product.fields.bookmarked.add(userId);
                                                  } else {
                                                    product.fields.bookmarked.remove(userId);
                                                  }
                                                });
                                              }
                                            } catch (e) {
                                              print("Error: $e");
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      });
                }
              }
            }));
  }
}
