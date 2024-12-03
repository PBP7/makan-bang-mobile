import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart'; // Model yang sudah diperbarui
import 'package:makan_bang/catalog/screens/productdetail.dart';
import 'package:makan_bang/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductEntryPage extends StatefulWidget {
  const ProductEntryPage({super.key});

  @override
  State<ProductEntryPage> createState() => _ProductEntryPageState();
}

class _ProductEntryPageState extends State<ProductEntryPage> {
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
    // MediaQuery untuk mendapatkan dimensi layar
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Faktor pengali berdasarkan ukuran layar (sedikit lebih besar dari sebelumnya)
    double scaleFactor = width / 450; // Pengali sedikit lebih besar agar elemen lebih responsif

    // Menentukan jumlah kolom berdasarkan ukuran lebar layar
    int crossAxisCount = width > 600 ? 3 : 2;

    // Menentukan batas maksimal lebar untuk item agar tidak terlalu besar
    double maxWidth = width > 1000 ? 1000 : width;  // Maksimal lebar 1000px untuk perangkat besar

    // Tentukan ukuran maksimal untuk gambar, font, dan elemen lainnya
    double maxImageHeight = 180; // Batas maksimal tinggi gambar
    double maxFontSize = 18; // Batas maksimal ukuran font

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProducts(request),
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
                  crossAxisSpacing: 12 * scaleFactor, // Sesuaikan spacing lebih kecil
                  mainAxisSpacing: 12 * scaleFactor, // Sesuaikan spacing lebih kecil
                  childAspectRatio: 0.7, // Rasio anak grid agar tidak terlalu tinggi
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  final product = snapshot.data[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Batasi ukuran lebar item untuk mencegah overflow pada layar besar
                      double itemWidth = constraints.maxWidth > maxWidth
                          ? maxWidth
                          : constraints.maxWidth;

                      // Ukuran gambar berdasarkan lebar item
                      double imageHeight = itemWidth * 0.5; // Ukuran gambar lebih besar
                      if (imageHeight > maxImageHeight) {
                        imageHeight = maxImageHeight; // Batasi tinggi gambar
                      }

                      // Ukuran font berdasarkan lebar item
                      double fontSize = itemWidth * 0.06; // Sedikit lebih besar dari sebelumnya
                      if (fontSize > maxFontSize) {
                        fontSize = maxFontSize; // Batasi ukuran font
                      }

                      // Ukuran harga lebih besar
                      double priceFontSize = fontSize * 1.2; // Harga lebih besar dari nama produk

                      // Mengurangi ukuran kotak kategori
                      double categoryFontSize = fontSize * 0.55; // Kecilkan ukuran font kategori
                      double categoryPadding = 4 * scaleFactor; // Padding kategori lebih kecil

                      return Card(
                        elevation: 8,
                        margin: EdgeInsets.all(10 * scaleFactor), // Margin lebih besar
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16 * scaleFactor),
                        ),
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(product: product),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16 * scaleFactor),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar Produk
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16 * scaleFactor)),
                                  child: product.fields.pictureLink.isNotEmpty
                                      ? Image.network(
                                          product.fields.pictureLink,
                                          height: imageHeight, // Ukuran gambar lebih besar
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image(
                                          image:
                                              const AssetImage('assets/placeholder.jpg'),
                                          height: 180 * scaleFactor, // Ukuran gambar responsif
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10 * scaleFactor), // Padding lebih besar
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      // Kategori (lebih kecil)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: categoryPadding,
                                            vertical: categoryPadding),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade700,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          product.fields.kategori,
                                          style: TextStyle(
                                            fontSize: categoryFontSize,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8 * scaleFactor),
                                      // Harga (lebih besar)
                                      Text(
                                        'Price: \$${product.fields.price}',
                                        style: TextStyle(
                                          fontSize: priceFontSize, // Ukuran harga lebih besar
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(height: 8 * scaleFactor),
                                      // Nama Restoran
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.restaurant,
                                            size: 20 * scaleFactor, // Ukuran ikon restoran sedikit lebih besar
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 8 * scaleFactor),
                                          Expanded(
                                            child: Text(
                                              product.fields.restaurant,
                                              style: TextStyle(
                                                fontSize: fontSize * 0.8,
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
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
