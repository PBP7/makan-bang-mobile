// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:makan_bang/catalog/models/product_entry.dart'; // Model yang sudah diperbarui
// import 'package:makan_bang/catalog/screens/productdetail.dart';
// import 'package:makan_bang/catalog/widgets/product_card_actions.dart';
// import 'package:makan_bang/models/user.dart.dart';
// import 'package:makan_bang/rate_review/models/ratereview_entry.dart';
// import 'package:makan_bang/rate_review/screens/reviewdetail.dart';
// import 'package:makan_bang/rate_review/widgets/buttondelay.dart';
// import 'package:makan_bang/widgets/left_drawer.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:makan_bang/catalog/widgets/floating_button.dart';

// class PersonalPage extends StatefulWidget {
//   final String productId;
//   final String productItem;
//   const PersonalPage({super.key, required this.productId, required this.productItem});

//   @override
//   State<PersonalPage> createState() => _PersonalPageState();
// }

// double getScaleFactor(double width) {
//   if (width <= 600) {
//     return (width / 450).clamp(0.8, 1.2); // Mobile
//   } else if (width <= 1024) {
//     return (width / 800).clamp(0.6, 1.0); // Tablet
//   } else {
//     return (width / 1400).clamp(0.5, 0.8); // Desktop
//   }
// }

// class _PersonalPageState extends State<PersonalPage> {
//   Future<List<RateReviewEntry>> fetchReview(CookieRequest request, String productId) async {
//     final response = await request.get('http://127.0.0.1:8000/rate_review//json/'); // INI 
//     List<RateReviewEntry> reviewList = [];
//     for (var d in response) {
//       if (d != null) {
//         reviewList.add(RateReviewEntry.fromJson(d));
//       }
//     }
//     return reviewList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     String productId = widget.productId;
//     final request = context.watch<CookieRequest>();
//     final user = context.watch<UserModel>();

//     // MediaQuery untuk mendapatkan dimensi layar
//     double width = MediaQuery.of(context).size.width;

//     // Hitung scaleFactor berdasarkan ukuran layar
//     double scaleFactor = getScaleFactor(width);

//     // Tentukan jumlah kolom untuk GridView
//     int crossAxisCount = width > 600 ? 3 : 2; // Mobile dan Tablet

//     // Tentukan batas maksimal lebar untuk item agar tidak terlalu besar
//     double maxWidth = width > 1000 ? 1000 : width; // Maksimal lebar 1000px untuk perangkat besar

//     // Tentukan ukuran maksimal untuk gambar, font, dan elemen lainnya
//     double maxImageHeight = 180; // Batas maksimal tinggi gambar
//     double maxFontSize = 18; // Batas maksimal ukuran font

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Review List'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // Kembali ke layar sebelumnya
//           },
//         ),
//       ),
//       drawer: const LeftDrawer(),
//       body: FutureBuilder<List<RateReviewEntry>>(
//         future: fetchReview(request, productId),
//         builder: (context, AsyncSnapshot<List<RateReviewEntry>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text(
//                 'Mohon maaf, kami belum menemukan review di product ini. Review sekarang juga!',
//                 style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
//               ),
//             );
//           } else {
//             return GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: crossAxisCount,
//                 crossAxisSpacing: 14 * scaleFactor, // Sesuaikan spacing lebih kecil
//                 mainAxisSpacing: 14 * scaleFactor, // Sesuaikan spacing lebih kecil
//                 childAspectRatio: 0.7, // Rasio anak grid agar tidak terlalu tinggi
//               ),
//               itemCount: snapshot.data!.length,
//               itemBuilder: (_, index) {
//                 final rateReviewEntry = snapshot.data![index];
//                 return LayoutBuilder(
//                   builder: (context, constraints) {
//                     // Batasi ukuran lebar item untuk mencegah overflow pada layar besar
//                     double itemWidth = constraints.maxWidth > maxWidth
//                         ? maxWidth
//                         : constraints.maxWidth;

//                     // Ukuran gambar berdasarkan lebar item
//                     double imageHeight = itemWidth * 0.5; // Ukuran gambar lebih besar
//                     if (imageHeight > maxImageHeight) {
//                       imageHeight = maxImageHeight; // Batasi tinggi gambar
//                     }

//                     // Ukuran font berdasarkan lebar item
//                     double fontSize = itemWidth * 0.6; // Sedikit lebih besar dari sebelumnya
//                     if (fontSize > maxFontSize) {
//                       fontSize = maxFontSize; // Batasi
//                     }

//                     // Mengurangi ukuran kotak kategori
//                     double categoryFontSize = fontSize * 1; // Kecilkan ukuran font kategori
//                     double categoryPadding = 4 * scaleFactor; // Padding kategori lebih kecil

//                     return Card(
//                       elevation: 8,
//                       margin: EdgeInsets.all(10 * scaleFactor), // Margin lebih besar
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16 * scaleFactor),
//                       ),
//                       child: InkWell(
//                         splashColor: Colors.blue.withAlpha(30),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   ReviewDetailPage(rateReviewEntry: rateReviewEntry),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16 * scaleFactor),
//                             gradient: LinearGradient(
//                               colors: [Colors.blueAccent.shade200, Colors.lightBlue.shade800],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.blueAccent.withOpacity(0.2),
//                                 spreadRadius: 4,
//                                 blurRadius: 8,
//                                 offset: Offset(2, 4),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(10 * scaleFactor),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // Nama Produk
//                                     Row(
//                                       children: [
//                                         Icon(Icons.person, color: Colors.white, size: 20 * scaleFactor),
//                                         SizedBox(width: 8 * scaleFactor),
//                                         Expanded(
//                                           child: Text(
//                                             productName,
//                                             style: TextStyle(
//                                               fontSize: fontSize,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                             ),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ],
//                                     ),

//                                     SizedBox(height: 8 * scaleFactor),

//                                     // Kategori
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: categoryPadding * 2,
//                                         vertical: categoryPadding,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.deepPurple.shade700,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Icon(Icons.category, color: Colors.white, size: 16 * scaleFactor),
//                                           SizedBox(width: 4 * scaleFactor),
//                                           Text(
//                                             rateReviewEntry.fields.rate?.toString() ?? "N/A",
//                                             style: TextStyle(
//                                               fontSize: categoryFontSize,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),

//                                     SizedBox(height: 8 * scaleFactor),

//                                     // Harga
//                                     Row(
//                                       children: List.generate(
//                                         rateReviewEntry.fields.rate?.toInt() ?? 0, // Jumlah ikon berdasarkan rating
//                                         (index) => const Icon(
//                                           Icons.star, // Ikon bintang
//                                           color: Colors.amber, // Warna ikon
//                                           size: 24.0, // Ukuran ikon
//                                         ),
//                                       ),
//                                     ),
                                    
//                                     SizedBox(height: 8 * scaleFactor),

//                                     Row(
//                                       children: [
//                                         Icon(Icons.rate_review_sharp, color: Colors.white70, size: 20* scaleFactor),
//                                         SizedBox(width: 8 * scaleFactor),
//                                         Expanded(
//                                           child: Text(
//                                             rateReviewEntry.fields.reviewText?.toString() ?? "No Review",
//                                             style: TextStyle(
//                                               fontSize: fontSize,
//                                               color: Colors.white70,
//                                             ),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               const Spacer(),

//                               // Tombol Interaktif
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 10 * scaleFactor),
//                                   child: rateReviewEntry.fields.user == user.name // Tampilkan hanya jika admin
//                                       ? ReviewAction(
//                                           rateReviewEntry: rateReviewEntry,
//                                           onUpdateSuccess: () {
//                                             setState(() {});
//                                           },
//                                         )
//                                       : const SizedBox.shrink(),
//                                 ),
//                                 SizedBox(height: 10 * scaleFactor), 
//                                 SizedBox(height: 10 * scaleFactor),
//                             ],
//                           ),
//                         ),

//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
