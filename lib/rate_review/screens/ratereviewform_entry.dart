// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:makan_bang/rate_review/models/ratereview_entry.dart';
// import 'package:makan_bang/rate_review/screens/reviewpage.dart';
// import 'package:makan_bang/catalog/models/product_entry.dart' as product_entry;
// import 'package:makan_bang/screens/menu.dart';
// import 'package:makan_bang/widgets/left_drawer.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:makan_bang/rate_review/models/ratereview_entry.dart'as rate_review_entry;

// class RateReviewEntryPage extends StatefulWidget {
//   final String productId;

//   RateReviewEntryPage({required this.productId});

//   @override
//   _RateReviewEntryPageState createState() => _RateReviewEntryPageState();
// }

// class _RateReviewEntryPageState extends State<RateReviewEntryPage> {
//   final List<rate_review_entry.RateReviewEntry> entries = [];
//   final TextEditingController _reviewTextController = TextEditingController();
//   int _rate = 1;

//   void _addEntry() {
//     final newEntry = rate_review_entry.RateReviewEntry(
//       model: "rate_review_entry",
//       pk: DateTime.now().millisecondsSinceEpoch.toString(),

//       fields: rate_review_entry.Fields(
//         user: , // Dummy user ID, replace with actual user logic
//         product: widget.productId, // Menggunakan productId yang dikirim
//         rate: _rate,
//         reviewText: _reviewTextController.text,
//         date: DateTime.now(),
//       ),
//     );

//     setState(() {
//       entries.add(newEntry);
//     });

//     _reviewTextController.clear();
//     _rate = 1;
//   }

//   void _deleteEntry(int index) {
//     setState(() {
//       entries.removeAt(index);
//     });
//   }

//   void _editEntry(int index) {
//     final entry = entries[index];
//     _reviewTextController.text = entry.fields.reviewText;
//     _rate = entry.fields.rate;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Edit Entry'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _reviewTextController,
//               decoration: InputDecoration(labelText: 'Review Text'),
//               maxLines: 3,
//             ),
//             Row(
//               children: [
//                 Text('Rate:'),
//                 Expanded(
//                   child: Slider(
//                     value: _rate.toDouble(),
//                     min: 1,
//                     max: 5,
//                     divisions: 4,
//                     label: '$_rate',
//                     onChanged: (value) {
//                       setState(() {
//                         _rate = value.toInt();
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 entries[index] = rate_review_entry.RateReviewEntry(
//                   model: entry.model,
//                   pk: entry.pk,
//                   fields: rate_review_entry.Fields(
//                     user: entry.fields.user,
//                     product: entry.fields.product,
//                     rate: _rate,
//                     reviewText: _reviewTextController.text,
//                     date: entry.fields.date,
//                   ),
//                 );
//               });
//               Navigator.of(context).pop();
//               _reviewTextController.clear();
//               _rate = 1;
//             },
//             child: Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rate & Review Entries'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Tidak perlu TextField untuk nama produk lagi
//             // Menampilkan ID produk yang dikirim
//             Text('Product ID: ${widget.productId}'),

//             TextField(
//               controller: _reviewTextController,
//               decoration: InputDecoration(labelText: 'Review Text'),
//               maxLines: 3,
//             ),
//             Row(
//               children: [
//                 Text('Rate:'),
//                 Expanded(
//                   child: Slider(
//                     value: _rate.toDouble(),
//                     min: 1,
//                     max: 5,
//                     divisions: 4,
//                     label: '$_rate',
//                     onChanged: (value) {
//                       setState(() {
//                         _rate = value.toInt();
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             ElevatedButton(
//               onPressed: _addEntry,
//               child: Text('Add Entry'),
//             ),
//             SizedBox(height: 20),

//             // Daftar entri review
//             Expanded(
//               child: entries.isEmpty
//                   ? Center(child: Text('No entries yet'))
//                   : ListView.builder(
//                       itemCount: entries.length,
//                       itemBuilder: (context, index) {
//                         final entry = entries[index];
//                         return Card(
//                           child: ListTile(
//                             title: Text(entry.fields.product),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Rate: ${entry.fields.rate}'),
//                                 Text('Review: ${entry.fields.reviewText}'),
//                                 Text('Date: ${entry.fields.date.toLocal()}'),
//                               ],
//                             ),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.edit, color: Colors.blue),
//                                   onPressed: () => _editEntry(index),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.delete, color: Colors.red),
//                                   onPressed: () => _deleteEntry(index),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
