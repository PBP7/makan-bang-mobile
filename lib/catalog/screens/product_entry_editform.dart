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
        title: const Center(
          child: Text(
            'Edit Produk',
          ),
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
              // Product Name
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
                  onChanged: (String? value) {
                    setState(() {
                      _item = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Item tidak boleh kosong!";
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
                  onChanged: (String? value) {
                    setState(() {
                      _pictureLink = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Picture link tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Description
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
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
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
                  onChanged: (String? value) {
                    setState(() {
                      _price = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Harga tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Harga harus berupa angka!";
                    }
                    return null;
                  },
                ),
              ),
              // Category
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
                  onChanged: (String? value) {
                    setState(() {
                      _kategori = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Kategori tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Restaurant
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
                  onChanged: (String? value) {
                    setState(() {
                      _restaurant = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Restaurant tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Location
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
                  onChanged: (String? value) {
                    setState(() {
                      _lokasi = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Lokasi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // GoFood Link
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _linkGofood,
                  decoration: InputDecoration(
                    hintText: "GoFood Link",
                    labelText: "GoFood Link",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _linkGofood = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "GoFood Link tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Nutrition Info
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
                  onChanged: (String? value) {
                    setState(() {
                      _nutrition = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nutrition tidak boleh kosong!";
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
                        // Send updated data to Django and wait for a response
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/katalog/edit-flutter/${_id}",
                          jsonEncode(<String, dynamic>{
                            'item': _item,
                            'picture_link': _pictureLink,
                            'description': _description,
                            'price':
                                _price, // Send price as an integer directly
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
                                  builder: (context) => MyHomePage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Terdapat kesalahan, silakan coba lagi."),
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
