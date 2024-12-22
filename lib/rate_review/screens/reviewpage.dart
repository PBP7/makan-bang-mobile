// import 'package:flutter/material.dart';
// import 'package:makan_bang/catalog/models/product_entry.dart'; // Model yang sudah diperbarui
// import 'package:makan_bang/catalog/screens/productdetail.dart';
// import 'package:makan_bang/catalog/widgets/product_card_actions.dart';
// import 'package:makan_bang/rate_review/models/ratereview_entry.dart';
// import 'package:makan_bang/models/user.dart.dart';
// import 'package:makan_bang/rate_review/screens/inner_reviewpage.dart';
// import 'package:makan_bang/rate_review/screens/ratereviewform_entry.dart';
// import 'package:makan_bang/widgets/left_drawer.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:makan_bang/catalog/models/product_entry.dart' as catalog;
// import 'package:makan_bang/rate_review/models/ratereview_entry.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


// class ReviewPage extends StatefulWidget {
//   final String productId; // Tambahkan field untuk menerima productId

//   const ReviewPage({Key? key, required this.productId}) : super(key: key);

//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }

// class _ReviewPageState extends State<ReviewPage> {
//   List<RateReviewEntry> listReview = [];
//   Map<String, Product> listProduct = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchProductAndReviews();
//   }

//   // Mengambil data produk dan review
//   Future<void> fetchProductAndReviews() async {
//     try {
//       // Ambil Produk
//       await fetchProduct();

//       // Ambil Review
//       await fetchReview();

//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   // Fetch Reviews dari server
//   Future<void> fetchReview() async {
//     final url = Uri.parse('https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/rate_review/show-flutter/');
//     final response = await http.get(
//       url,
//       headers: {"Content-Type": "application/json"},
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(utf8.decode(response.bodyBytes));

//       setState(() {
//         listReview = data.map<RateReviewEntry>((d) => RateReviewEntry.fromJson(d)).toList();
//         isLoading = false;
//       });
//     } else {
//       print('Failed to load reviews');
//     }
//   }

//   // Fetch Product dari server
//   Future<void> fetchProduct() async {
//     final url = Uri.parse('https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/katalog/json/');
//     final response = await http.get(
//       url,
//       headers: {"Content-Type": "application/json"},
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(utf8.decode(response.bodyBytes));

//       setState(() {
//         listProduct = {for (var d in data) d["pk"].toString(): Product.fromJson(d)};
//       });
//     } else {
//       print('Failed to load products');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();

//     return Scaffold(
//       appBar: appBar(),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(height: 10),
//               const SizedBox(
//                 width: 425,
//                 child: Text(
//                   "Our Reviews",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     color: Color(0xFF146C94),
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   showRedirectingSnackbar(context); // Show snackbar
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const InnerReviewPage(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(80, 40),
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: const Text(
//                   "Review Our Foodie Now!",
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 50),
//               // Menampilkan review jika sudah diambil
//               if (isLoading) 
//                 const CircularProgressIndicator(),
//               if (!isLoading && listReview.isEmpty)
//                 const Text('No reviews available'),
//               if (!isLoading && listReview.isNotEmpty)
//                 ...listReview.map((review) => ListTile(
//                   title: Text('${review.fields.user} - Rating: ${review.fields.rate}'),
//                   subtitle: Text(review.fields.reviewText),
//                   trailing: Text(review.fields.date.toIso8601String()),
//                 )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // AppBar
//   AppBar appBar() {
//     return AppBar(
//       title: const Text(
//         'Review Here!',
//         style: TextStyle(
//           color: Color(0xFF005B9C),
//           fontFamily: 'Inter',
//           fontSize: 25,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       iconTheme: const IconThemeData(color: Colors.black),
//       backgroundColor: Colors.white,
//       centerTitle: true,
//       elevation: 0.0,
//     );
//   }

//   // Menampilkan Snackbar saat redirect
//   void showRedirectingSnackbar(BuildContext context) {
//     const snackBar = SnackBar(
//       content: Text('Directing to our catalog...'),
//       backgroundColor: Color(0xFF0C356A),
//       duration: Duration(seconds: 3),
//     );

//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }