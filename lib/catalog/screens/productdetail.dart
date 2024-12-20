import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product}); // Gunakan parameter yang wajib

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
                children: [
                  const Icon(Icons.restaurant, size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    product.fields.restaurant,
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Lokasi
              Row(
                children: [
                  const Icon(Icons.location_on, size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      product.fields.lokasi,
                      style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Nutrisi
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      product.fields.nutrition,
                      style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Navigating to GoFood: ${product.fields.linkGofood}')),
                      );
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
                "Price: \$${product.fields.price}",
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
