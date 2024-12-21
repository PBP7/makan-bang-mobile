import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String _name = '';
  int _id = 0;

  String get name => _name;
  int get id => _id;

  // Menyimpan nama pengguna setelah login
  void setUser(String name, int id) {
    _name = name;
    _id = id;
    notifyListeners();
  }

  // Menghapus data pengguna untuk logout
  void clearUser() {
    _name = '';
    _id = 0;
    notifyListeners();
  }
}
