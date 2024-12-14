import 'package:flutter/material.dart';
import 'package:makan_bang/screens/menu.dart';
import 'package:makan_bang/catalog/screens/product_entryform.dart';
import 'package:makan_bang/catalog/screens/list_productentry.dart';
import 'package:makan_bang/forum/screens/view_forum.dart';

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
                  'MAKAN BANG',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Ayo jaga kesehatan mentalmu setiap hari disini!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
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
            leading: const Icon(Icons.add_circle_outline_sharp),
            title: const Text('Add Product'),
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
            leading: const Icon(Icons.menu_book),
            title: const Text('Catalogue'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductEntryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_quote_rounded),
            title: const Text('Forum'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForumPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}