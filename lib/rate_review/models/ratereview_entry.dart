// To parse this JSON data, do
//
//     final rateReviewEntry = rateReviewEntryFromJson(jsonString);

import 'dart:convert';

List<RateReviewEntry> rateReviewEntryFromJson(String str) => List<RateReviewEntry>.from(json.decode(str).map((x) => RateReviewEntry.fromJson(x)));

String rateReviewEntryToJson(List<RateReviewEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RateReviewEntry {
    final String model;
    final String pk;
    final Fields fields;

    RateReviewEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory RateReviewEntry.fromJson(Map<String, dynamic> json) => RateReviewEntry(
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
    final String user;
    final String product;
    final int rate;
    final String reviewText;
    final DateTime date;

    Fields({
        required this.user,
        required this.product,
        required this.rate,
        required this.reviewText,
        required this.date,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        product: json["product"],
        rate: json["rate"],
        reviewText: json["review_text"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "product": product,
        "rate": rate,
        "review_text": reviewText,
        "date": date.toIso8601String(),
    };
}
