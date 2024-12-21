import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
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
        title: Text(product.fields.item),
      ),
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
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.fields.kategori,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
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
                      product.fields.lokasi,
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
                  const Icon(Icons.link, size: 20, color: Colors.blue),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      // Tindakan ketika link GoFood diklik
                      _launchGoFoodLink(product.fields.linkGofood);
                    },
                    child: const Text(
                      'View in GoFood',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
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
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.green,
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
            ],
          ),
        ),
      ),
    );
  }
}
