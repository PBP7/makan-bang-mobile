import 'package:flutter/material.dart';
import 'package:makan_bang/screens/menu.dart';
import 'package:makan_bang/catalog/screens/product_entryform.dart';
import 'package:makan_bang/catalog/screens/list_productentry.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
    ),
    child: const Column(
      children: [
        Text(
          'Mental Health Tracker',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Padding(padding: EdgeInsets.all(8)),
        Text(
          "Ayo jaga kesehatan mentalmu setiap hari disini!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
          ),
  ListTile(
    leading: const Icon(Icons.home_outlined),
    title: const Text('Halaman Utama'),
    // Bagian redirection ke MyHomePage
    onTap: () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ));
    },
  ),
  ListTile(
    leading: const Icon(Icons.mood),
    title: const Text('Lihat Menu'),
    // Bagian redirection ke MoodEntryFormPage
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductEntryFormPage(),
          ));
    },
  ),
  ListTile(
    leading: const Icon(Icons.add_reaction_rounded),
    title: const Text('Daftar Mood'),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProductEntryPage()),
      );
    },
  ),
        ],
      ),
    );
  }
}