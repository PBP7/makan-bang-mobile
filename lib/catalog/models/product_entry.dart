import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String model;
  String pk;
  Fields fields;

  Product({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String item;
  String pictureLink;
  String restaurant;
  String kategori;
  String lokasi;
  int price;
  String nutrition;
  String description;
  String linkGofood;
  bool isDatasetProduct; // Atribut untuk menandai produk dataset
  // Atribut 'bookmarked' tidak akan disertakan di katalog

  Fields({
    required this.item,
    required this.pictureLink,
    required this.restaurant,
    required this.kategori,
    required this.lokasi,
    required this.price,
    required this.nutrition,
    required this.description,
    required this.linkGofood,
    this.isDatasetProduct = false, // Nilai default adalah false
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        item: json["item"],
        pictureLink: json["picture_link"],
        restaurant: json["restaurant"],
        kategori: json["kategori"],
        lokasi: json["lokasi"],
        price: json["price"],
        nutrition: json["nutrition"],
        description: json["description"],
        linkGofood: json["link_gofood"],
        isDatasetProduct: json["is_dataset_product"] ?? false, // Nilai default false
      );

  Map<String, dynamic> toJson() => {
        "item": item,
        "picture_link": pictureLink,
        "restaurant": restaurant,
        "kategori": kategori,
        "lokasi": lokasi,
        "price": price,
        "nutrition": nutrition,
        "description": description,
        "link_gofood": linkGofood,
        "is_dataset_product": isDatasetProduct, // Jika diperlukan di JSON
      };

  // Properti untuk menampilkan produk tanpa atribut yang tidak diinginkan
  Map<String, dynamic> catalogDisplay() => {
        "item": item,
        "picture_link": pictureLink,
        "restaurant": restaurant,
        "kategori": kategori,
        "lokasi": lokasi,
        "price": price,
        "nutrition": nutrition,
        "description": description,
        "link_gofood": linkGofood,
      };
}
