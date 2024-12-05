import 'package:flutter/material.dart';
import 'package:makan_bang/models/user.dart.dart';
import 'package:makan_bang/screens/menu.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:makan_bang/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Menyediakan CookieRequest
        Provider(
          create: (_) {
            CookieRequest request = CookieRequest();
            return request;
          },
        ),
        // Menyediakan UserModel
        ChangeNotifierProvider(
          create: (_) => UserModel(),  // Menggunakan UserModel untuk menyimpan dan mengelola status user
        ),
      ],
      child: MaterialApp(
        title: 'Mental Health Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.deepPurple[400]),
        ),
        home: const LoginPage(),  // Halaman login yang akan memulai aplikasi
      ),
    );
  }
}
