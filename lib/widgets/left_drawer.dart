import 'package:flutter/material.dart';
import 'package:makan_bang/preference/screens/preference_page.dart';
import 'package:makan_bang/bookmark/screens/list_bookmark.dart';
import 'package:makan_bang/meal_planning/screens/first_page_meal_plan.dart';
import 'package:makan_bang/rate_review/screens/listreview_entry.dart';
import 'package:makan_bang/screens/menu.dart';
import 'package:makan_bang/screens/login.dart';
import 'package:makan_bang/catalog/screens/product_entryform.dart';
import 'package:makan_bang/catalog/screens/list_productentry.dart';
import 'package:makan_bang/forum/screens/view_forum.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  bool isAuthenticated = false;
  String? username;

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get("https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/auth/status/");
      setState(() {
        isAuthenticated = response['is_authenticated'];
        username = response['username'];
      });
    } catch (e) {
      setState(() {
        isAuthenticated = false;
        username = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: const Color.fromARGB(255, 251, 250, 246),
      ),
      child: Drawer(
        backgroundColor: const Color.fromARGB(255, 251, 250, 246),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color.fromARGB(255, 251, 250, 246),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MAKAN BANG',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isAuthenticated && username != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Hungry, $username?',
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined, color: Colors.black),
                    title: const Text('Home', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  if (isAuthenticated && (username?.toLowerCase() == 'admin')) ...[
                    ListTile(
                      leading: const Icon(Icons.add_circle_outline_sharp, color: Colors.black),
                      title: const Text('Add Product', style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProductEntryFormPage()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                  ],
                  ListTile(
                    leading: Icon(Icons.menu_book, color: Colors.blue[900]),
                    title: const Text('Catalogue', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductEntryPage()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.fastfood_outlined, color: Colors.green[400]),
                    title: const Text('Preference', style: TextStyle(color: Colors.black)),
                    onTap: () async {
                      final request = context.read<CookieRequest>();
                      try {
                        final response = await request.get("https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/auth/status/");
                        if (response['is_authenticated']) {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PreferencePage()),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Log in or register to access preference page!"),
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
                              content: Text("Error."),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.list_alt, color: Colors.yellow[800]),
                    title: const Text('Meal Plan', style: TextStyle(color: Colors.black)),
                    onTap: () async {
                      final request = context.read<CookieRequest>();
                      try {
                        final response = await request.get("https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/auth/status/");
                        if (response['is_authenticated']) {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MealPlanScreen()),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please login first to access Meal Plan!"),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Error checking authentication status"),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.bookmark_add, color: Colors.blue[900]),
                    title: const Text('Bookmark', style: TextStyle(color: Colors.black)),
                    onTap: () async {
                      final request = context.read<CookieRequest>();
                      try {
                        final response = await request.get("https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/auth/status/");
                        if (response['is_authenticated']) {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BookmarksPage()),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Log in or register to access bookmarks!"),
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
                              content: Text("Error."),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.format_quote_rounded, color: Colors.pink[300]),
                    title: const Text('Forum', style: TextStyle(color: Colors.black)),
                    onTap: () async {
                      final request = context.read<CookieRequest>();
                      try {
                        final response = await request.get("https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/auth/status/");
                        if (response['is_authenticated']) {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ForumPage()),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Log in or register to access forum!"),
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
                              content: Text("Error."),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
            
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 251, 250, 246),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              alignment: Alignment.centerLeft,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Privacy Policy', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Disclaimer', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Contact Us', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('FAQ', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find Us',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/iconx.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/iconinstagram.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/iconpinterest.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: ListTile(
                leading: Icon(
                  isAuthenticated ? Icons.logout : Icons.login,
                  color: isAuthenticated ? Colors.red[900] : Colors.blue[900],
                ),
                title: Text(
                  isAuthenticated ? 'Logout' : 'Login',
                  style: TextStyle(
                    color: isAuthenticated ? Colors.red[900] : Colors.blue[900],
                  ),
                ),
                onTap: () async {
                  if (isAuthenticated) {
                    final response = await request.logout(
                      "https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/authmobile/logout/");
                    String message = response["message"];
                    if (context.mounted) {
                      if (response['status']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$message Sampai jumpa, $username."),
                          ),
                        );
                        setState(() {
                          isAuthenticated = false;
                          username = null;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      }
                    }
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}