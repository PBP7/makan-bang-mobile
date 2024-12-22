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
class ReviewEdit extends StatefulWidget {
  final Map<String, dynamic> productData; // Data produk yang akan diedit

  const ReviewEdit(
      {super.key, required this.productData, required RateReviewEntry rateReviewEntry});

  @override
  State<ReviewEdit> createState() => _ReviewEditState();
}

class _ReviewEditState extends State<ReviewEdit> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late int _rate; // Default nilai rating (di tengah slider)
  late String _review;

  @override
  void initState() {
    super.initState();
    _id = widget.productData['pk'];
    _rate = widget.productData['rate'];
    _review = widget.productData['reviewText'];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = context.watch<UserModel>(); 

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Edit Review',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating (Slider)
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _review, // Menambahkan nilai awal dari _review
                  decoration: InputDecoration(
                    hintText: "Tulis review Anda",
                    labelText: "Review",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  maxLines: 3, // Membatasi jumlah baris input
                  onChanged: (String? value) {
                    setState(() {
                      _review = value!; // Menyimpan nilai review yang diubah
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print(_id);
                        // Send data to Django and wait for a response
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/rate_review/edit-flutter/${_id}", // Perbaiki URL
                          jsonEncode(<String, dynamic>{
                            "user": user.name, 
                            "product": widget.productData['product'],
                            "rate": _rate, // Gunakan int langsung
                            "review": _review,
                          }),
                        );
                        print(
                          jsonEncode(<String, dynamic>{
                            "user": user.name, 
                            "product": widget.productData['product'],
                            "rate": _rate, // Gunakan int langsung
                            "review": _review,
                          }),
                        );
                        if (context.mounted) {
                          print(response);
                          if (response['status'] == 'success' || response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Review baru berhasil disimpan!"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ReviewEntryPage(productId: widget.productData['product'],)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Terdapat kesalahan, apakah anda pernah mengisi review di menu ini? Silakan coba lagi."),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ReviewEntryPage(productId: _id,)),
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
    );
  }
}
