import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/catalog/widgets/floating_button.dart';
import 'package:makan_bang/rate_review/models/ratereview_entry.dart';
import 'package:makan_bang/rate_review/screens/listreview_entry.dart';
import 'package:makan_bang/models/user.dart.dart';
import 'package:makan_bang/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'dart:convert';

class ReviewDetailPage extends StatelessWidget {
  final RateReviewEntry rateReviewEntry;

  const ReviewDetailPage({super.key, required this.rateReviewEntry}); // Gunakan parameter yang wajib

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel>(); 
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
      floatingActionButton: user.name == 'admin' // Cek apakah user adalah admin
          ? const ShopFloatingActionButton() // Tampilkan FAB hanya untuk admin
          : null,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Produk
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
                  rateReviewEntry.fields.product,
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
                '⭐' * rateReviewEntry.fields.rate,
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
                    rateReviewEntry.fields.reviewText,
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              // Tombol untuk melihat review
            ],
          ),
        ),
      ),
    );
  }
}
