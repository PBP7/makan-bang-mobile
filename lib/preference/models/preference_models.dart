import 'dart:convert';

List<PreferenceItem> preferenceFromJson(String str) => 
    List<PreferenceItem>.from(json.decode(str).map((x) => PreferenceItem.fromJson(x)));

String preferenceToJson(List<PreferenceItem> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PreferenceItem {
    String name;
    String description;
    int price;
    String kategori;
    String pictureLink;
    String restaurant;
    String lokasi;
    String nutrition;
    String linkGofood;

    PreferenceItem({
        required this.name,
        required this.description,
        required this.price,
        required this.kategori,
        required this.pictureLink,
        required this.restaurant,
        required this.lokasi,
        required this.nutrition,
        required this.linkGofood,
    });

    factory PreferenceItem.fromJson(Map<String, dynamic> json) => PreferenceItem(
        name: json["name"],
        description: json["description"],
        price: json["price"],
        kategori: json["kategori"],
        pictureLink: json["picture_link"],
        restaurant: json["restaurant"],
        lokasi: json["lokasi"],
        nutrition: json["nutrition"],
        linkGofood: json["link_gofood"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "kategori": kategori,
        "picture_link": pictureLink,
        "restaurant": restaurant,
        "lokasi": lokasi,
        "nutrition": nutrition,
        "link_gofood": linkGofood,
    };
} 