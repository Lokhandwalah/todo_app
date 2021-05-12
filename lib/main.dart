import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/api/auth_api.dart';
import 'package:todo_app/provider/user.dart';

import 'screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NanumGothic',
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), _navigateNext);
  }

  void _navigateNext() async {
    final _auth = AuthService();
    bool isLoggedIn = true; // _auth.isUserLoggedIn();
    if (isLoggedIn) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await MyUser().setCurrentUserData('husain.l@somaiya.edu'
          // prefs.getString('email')
          );
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return _auth.isUserLoggedIn()
              ? Homepage()
              : ChangeNotifierProvider.value(
                  value: MyUser.currentUser, child: Homepage());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              height: 200,
            ),
            SizedBox(height: 20),
            Center(
                child: Text(
              'To-Do List',
              style: Theme.of(context).textTheme.headline4,
            )),
            SizedBox(height: 60),
            SpinKitDualRing(color: Colors.purple),
          ],
        ),
      ),
    );
  }
}
