import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:makan_bang/screens/menu.dart';
import 'package:makan_bang/widgets/left_drawer.dart';

class ProductEntryEditPage extends StatefulWidget {
  final Map<String, dynamic> productData; // Data produk yang akan diedit

  const ProductEntryEditPage(
      {super.key, required this.productData, required Product product});

  @override
  State<ProductEntryEditPage> createState() => _ProductEntryEditPageState();
}

class _ProductEntryEditPageState extends State<ProductEntryEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late String _item;
  late String _pictureLink;
  late String _description;
  late int _price;
  late String _kategori;
  late String _restaurant;
  late String _lokasi;
  late String _linkGofood;
  late String _nutrition;

  @override
  void initState() {
    super.initState();
    // Inisialisasi form dengan data yang ada
    _id = widget.productData['pk'];
    _item = widget.productData['item'];
    _pictureLink = widget.productData['picture_link'];
    _description = widget.productData['description'];
    _price = widget.productData['price'];
    _kategori = widget.productData['kategori'];
    _restaurant = widget.productData['restaurant'];
    _lokasi = widget.productData['lokasi'];
    _linkGofood = widget.productData['link_gofood'];
    _nutrition = widget.productData['nutrition'];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item (max_length=50)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _item,
                  decoration: InputDecoration(
                    hintText: "Item",
                    labelText: "Item",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _item = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Item tidak boleh kosong!";
                    }
                    if (value.length > 50) {
                      return "Item tidak boleh lebih dari 50 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // Picture Link
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _pictureLink,
                  decoration: InputDecoration(
                    hintText: "Picture link",
                    labelText: "Picture link",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _pictureLink = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Picture link tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // Description (max_length=255)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    hintText: "Deskripsi",
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    if (value.length > 255) {
                      return "Deskripsi tidak boleh lebih dari 255 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // Price
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _price.toString(),
                  decoration: InputDecoration(
                    hintText: "Harga",
                    labelText: "Harga",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _price = int.tryParse(value) ?? 0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harga tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Harga harus berupa angka!";
                    }
                    if (int.tryParse(value)! < 0) {
                      return "Harga tidak boleh negatif!";
                    }
                    return null;
                  },
                ),
              ),

              // Kategori (max_length=31)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _kategori,
                  decoration: InputDecoration(
                    hintText: "Kategori",
                    labelText: "Kategori",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _kategori = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kategori tidak boleh kosong!";
                    }
                    if (value.length > 31) {
                      return "Kategori tidak boleh lebih dari 31 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // Restaurant (max_length=90)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _restaurant,
                  decoration: InputDecoration(
                    hintText: "Restaurant",
                    labelText: "Restaurant",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _restaurant = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Restaurant tidak boleh kosong!";
                    }
                    if (value.length > 90) {
                      return "Restaurant tidak boleh lebih dari 90 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // Location (max_length=175)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _lokasi,
                  decoration: InputDecoration(
                    hintText: "Lokasi",
                    labelText: "Lokasi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _lokasi = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Lokasi tidak boleh kosong!";
                    }
                    if (value.length > 175) {
                      return "Lokasi tidak boleh lebih dari 175 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // Nutrition (max_length=150)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _nutrition,
                  decoration: InputDecoration(
                    hintText: "Nutrition Info",
                    labelText: "Nutrition Info",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _nutrition = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nutrition tidak boleh kosong!";
                    }
                    if (value.length > 150) {
                      return "Nutrition tidak boleh lebih dari 150 karakter!";
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/katalog/edit-flutter/$_id",
                          jsonEncode(<String, dynamic>{
                            'item': _item,
                            'picture_link': _pictureLink,
                            'description': _description,
                            'price': _price,
                            'kategori': _kategori,
                            'restaurant': _restaurant,
                            'lokasi': _lokasi,
                            'link_gofood': _linkGofood,
                            'nutrition': _nutrition,
                          }),
                        );

                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Produk berhasil diperbarui!"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Terdapat kesalahan, silakan coba lagi."),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Update",
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
