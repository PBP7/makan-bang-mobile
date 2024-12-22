import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/widgets/left_drawer.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:makan_bang/rate_review/models/ratereview_entry.dart';
import 'package:makan_bang/rate_review/screens/addreview.dart';
import 'package:makan_bang/rate_review/screens/listreview_entry.dart';
import 'package:makan_bang/rate_review/screens/ratereviewform_entry.dart';
import 'package:makan_bang/rate_review/screens/reviewpage.dart';
import 'package:makan_bang/rate_review/widgets/buttondelay.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product}); // Gunakan parameter yang 
  // Fungsi untuk membuka link
  Future<void> _launchGoFoodLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); // Buka di aplikasi eksternal
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Produk
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: product.fields.pictureLink.isNotEmpty
                    ? Image.network(
                        product.fields.pictureLink,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : const Text(
                        'No Image Available',
                        style: TextStyle(color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 20),
              // Kategori Produk
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.fields.kategori,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Nama Produk
              Text(
                product.fields.item,
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Nama Restoran
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Pastikan icon tetap di atas

                children: [
                  const Icon(Icons.restaurant, size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  Flexible( // Ganti Expanded menjadi Flexible
                    child: Text(
                      product.fields.restaurant,
                      style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                      overflow: TextOverflow.visible, // Biarkan teks meluas jika perlu
                      maxLines: null, // Izinkan teks turun ke bawah
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Lokasi
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Pastikan icon tetap di atas
                children: [
                  const Icon(Icons.location_on, size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  Flexible( // Ganti Expanded menjadi Flexible
                    child: Text(
                      product.fields.lokasi,
                      style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                      overflow: TextOverflow.visible, // Biarkan teks meluas jika perlu
                      maxLines: null, // Izinkan teks turun ke bawah
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Pastikan icon tetap di atas
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  Flexible( // Ganti Expanded menjadi Flexible
                    child: Text(
                      product.fields.nutrition,
                      style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                      overflow: TextOverflow.visible, // Biarkan teks meluas jika perlu
                      maxLines: null, // Izinkan teks turun ke bawah
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              // Link GoFood
              Row(
                children: [
                  Icon(Icons.link, size: 20, color: Colors.blue[900]),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      // Tindakan ketika link GoFood diklik
                      _launchGoFoodLink(product.fields.linkGofood);
                    },
                    child: Text(
                      'View in GoFood',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue[900],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Harga
              Text(
                "Price: Rp${product.fields.price}",
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.green[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Deskripsi Produk
              Text(
                product.fields.description,
                style: const TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'See what people say...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewEntryPage(productId: product.pk),
                          ),
                        );
                      },
                      icon: const Icon(Icons.star_rate_rounded),
                      label: const Text('View All Reviews'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        elevation: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => AddReview(productId: product.pk),
                        );
                      },
                      icon: const Icon(Icons.rate_review_rounded),
                      label: const Text('Write a Review'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2C5282),
                        side: const BorderSide(color: Color(0xFF2C5282)), // Matching blue for border
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
