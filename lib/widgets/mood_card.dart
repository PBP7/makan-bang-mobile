import 'package:flutter/material.dart';
import 'package:makan_bang/meal_planning/screens/first_page_meal_plan.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:makan_bang/screens/login.dart';
import 'package:makan_bang/forum/screens/view_forum.dart';
import 'package:makan_bang/catalog/screens/list_productentry.dart';
import 'package:makan_bang/preference/screens/preference_page.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    Future<void> handleAuthNavigation({
      required BuildContext context,
      required String feature,
      required Widget destination,
    }) async {
      try {
        final response = await request.get("http://127.0.0.1:8000/auth/status/");
        if (response['is_authenticated']) {
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }else if (item.name == "Meal Plan") {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => const MealPlanScreen()
                ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Log in or register to access $feature!"),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error connecting to server."),
            ),
          );
        }
      }
    }

    return Material(
      color: Colors.amber[50],
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          switch (item.name) {
            case "Forum":
              await handleAuthNavigation(
                context: context,
                feature: "forum",
                destination: const ForumPage(),
              );
              break;
            
            case "Rate and Review ":
              await handleAuthNavigation(
                context: context,
                feature: "review page",
                destination: const ForumPage(), // GANTI
              );
              break;
            
            case "Preference":
              await handleAuthNavigation(
                context: context,
                feature: "preference page",
                destination: const PreferencePage(),
              );
              break;
            
            case "Meal Plan":
              await handleAuthNavigation(
                context: context,
                feature: "meal plan",
                destination: const ForumPage(), // GANTI
              );
              break;
            
            case "Bookmark":
              await handleAuthNavigation(
                context: context,
                feature: "bookmarks",
                destination: const ForumPage(), // GANTI
              );
              break;
            
            case "Catalogue":
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductEntryPage()),
              );
              break;
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: item.color,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  ItemHomepage(this.name, this.icon, this.color);
}