import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/api/firebase_api.dart';

class MyUser extends ChangeNotifier {
  MyUser({
    this.name,
    this.email,
  });

  String name, email;
  static MyUser currentUser;

  Future<void> setCurrentUserData(
    String email, {
    String name,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    currentUser = name != null
        ? MyUser(email: email, name: name)
        : await FirebaseApi.getMyUser(email);
    notifyListeners();
  }

  void resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    currentUser = null;
    notifyListeners();
  }
}
