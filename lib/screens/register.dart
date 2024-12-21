import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:makan_bang/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    final Size screenSize = MediaQuery.of(context).size;
    
    final double widthMultiplier = screenSize.width / 400;
    final double heightMultiplier = screenSize.height / 800;
    
    final double titleFontSize = 32 * widthMultiplier.clamp(0.8, 1.5);
    final double welcomeFontSize = 28 * widthMultiplier.clamp(0.8, 1.5);
    final double brandFontSize = 30 * widthMultiplier.clamp(0.8, 1.5);
    final double subtitleFontSize = 16 * widthMultiplier.clamp(0.8, 1.2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0 * widthMultiplier.clamp(0.8, 1.2)),
          child: Card(
            elevation: 4,
            color: const Color.fromARGB(255, 251, 250, 246),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0 * widthMultiplier.clamp(0.8, 1.2)),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0 * widthMultiplier.clamp(0.8, 1.2)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Welcome text section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Hello there,',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Wrap( // Using Wrap instead of Row
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'welcome to ',
                            style: TextStyle(
                              fontSize: welcomeFontSize,
                            ),
                          ),
                          Text(
                            'MAKAN BANG',
                            style: TextStyle(
                              fontSize: brandFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12 * heightMultiplier),
                      Text(
                        'create your account!',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: const Color(0xFFD4AF37),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 32 * heightMultiplier),

                  // Username field
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Choose a username',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: subtitleFontSize,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        borderSide: BorderSide(color: Colors.grey[350]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        borderSide: BorderSide(color: Colors.grey[350]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0 * widthMultiplier.clamp(0.8, 1.2),
                        vertical: 16.0 * heightMultiplier.clamp(0.8, 1.2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16 * heightMultiplier),

                  // Password field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Create a password',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: subtitleFontSize,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        borderSide: BorderSide(color: Colors.grey[350]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        borderSide: BorderSide(color: Colors.grey[350]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0 * widthMultiplier.clamp(0.8, 1.2),
                        vertical: 16.0 * heightMultiplier.clamp(0.8, 1.2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16 * heightMultiplier),

                  // Confirm Password field
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: subtitleFontSize,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        borderSide: BorderSide(color: Colors.grey[350]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        borderSide: BorderSide(color: Colors.grey[350]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0 * widthMultiplier.clamp(0.8, 1.2),
                        vertical: 16.0 * heightMultiplier.clamp(0.8, 1.2),
                      ),
                    ),
                  ),
                  SizedBox(height: 32 * heightMultiplier),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        String username = _usernameController.text;
                        String password1 = _passwordController.text;
                        String password2 = _confirmPasswordController.text;

                        final response = await request.postJson(
                            "http://127.0.0.1:8000/auth/register-mobile/",
                            jsonEncode({
                              "username": username,
                              "password1": password1,
                              "password2": password2,
                            }));
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Successfully registered!'),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to register!'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF96C7B4),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0 * heightMultiplier.clamp(0.8, 1.2)
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0 * widthMultiplier.clamp(0.8, 1.2)),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24 * heightMultiplier),

                  // Login link
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 14 * widthMultiplier.clamp(0.8, 1.2),
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: Text(
                          'Login Now',
                          style: TextStyle(
                            fontSize: 14 * widthMultiplier.clamp(0.8, 1.2),
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}