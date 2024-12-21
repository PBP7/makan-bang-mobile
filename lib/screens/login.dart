import 'package:flutter/material.dart';
import 'package:makan_bang/models/user.dart.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'register.dart';
import 'package:makan_bang/screens/menu.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.deepPurple[400]),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        title: const Text('Login'),
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
                      Wrap(
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
                        'sign back in with your password!',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: const Color(0xFFD4AF37),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 32 * heightMultiplier),

                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your username',
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

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
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

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        String username = _usernameController.text;
                        String password = _passwordController.text;

                        final response = await request
                            .login("http://127.0.0.1:8000/auth/login-mobile/", {
                          'username': username,
                          'password': password,
                        });

                        if (request.loggedIn) {
                          String message = response['message'];
                          String uname = response['username'];
                          int id = response['id'];
                          // ignore: use_build_context_synchronously
                          context.read<UserModel>().setUser(uname,id);

                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyHomePage()),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content:
                                      Text("$message Selamat datang, $uname."),
                                ),
                              );
                          }
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Login Gagal'),
                                content: Text(response['message']),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
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
                        'Sign in',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24 * heightMultiplier),

                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet? ",
                        style: TextStyle(
                          fontSize: 14 * widthMultiplier.clamp(0.8, 1.2),
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          'Register Now',
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