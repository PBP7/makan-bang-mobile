import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/models/user.dart.dart';
import 'package:makan_bang/rate_review/models/ratereview_entry.dart';
import 'package:makan_bang/rate_review/screens/listreview_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:makan_bang/screens/menu.dart';

import 'package:makan_bang/widgets/left_drawer.dart';

class AddReview extends StatefulWidget {
  final String productId;
  const AddReview({super.key, required this.productId});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final _formKey = GlobalKey<FormState>();

  int _rate = 3; // Default nilai rating (di tengah slider)
  String _review = "";

  @override
  @override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
  final user = context.watch<UserModel>();

  return Scaffold(
    appBar: AppBar(
      title: const Center(
        child: Text(
          'Add Review',
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context); // Kembali ke layar sebelumnya
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
    ),
    drawer: const LeftDrawer(),
    body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),  // Menambahkan padding agar konten lebih teratur
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating (Slider)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rating",
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _rate.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _rate.toString(),
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey.shade300,
                      onChanged: (double value) {
                        setState(() {
                          _rate = value.toInt();
                        });
                      },
                    ),
                    Text(
                      'Rating kamu: $_rate bintang',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              // Review
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Tulis review Anda",
                    labelText: "Review",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _review = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Review tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Submit Button
              SizedBox(
                width: double.infinity,  // Membuat tombol submit memenuhi lebar layar
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Send data to Django and wait for a response
                        final response = await request.post(
                          "https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/rate_review/create-flutter/",
                          jsonEncode(<String, String>{
                            "user": user.name,
                            "product": widget.productId,
                            "rate": _rate.toString(),
                            "review": _review,
                          }),
                        );
                        if (context.mounted) {
                          print(response);
                          if (response['status'] == 'success' || response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Review berhasil disimpan!"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ReviewEntryPage(productId: widget.productId)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Terdapat kesalahan, silakan coba lagi."),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ReviewEntryPage(productId: widget.productId)),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
