import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String _name = '';

  String get name => _name;

  // Menyimpan nama pengguna setelah login
  void setUser(String name) {
    _name = name;
    notifyListeners();
  }

  // Menghapus data pengguna untuk logout
  void clearUser() {
    _name = '';
    notifyListeners();
  }
}
