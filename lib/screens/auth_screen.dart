// import 'package:canteen/screens/user_auth/login_form.dart';
// import 'package:canteen/screens/user_auth/signup_form.dart';
// import 'package:flip_card/flip_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final _flipKey = GlobalKey<FlipCardState>();
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         SystemNavigator.pop();
//         return Future.value(true);
//       },
//       child: Scaffold(
//         body: SafeArea(
//             child: Container(
//           width: MediaQuery.of(context).size.width,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: 80),
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: FittedBox(
//                       child: Text(
//                     'To-do List',
//                     style: TextStyle(fontSize: 30, color:  Colors.blue),
//                   )),
//                 ),
//                 FlipCard(
//                     key: _flipKey,
//                     flipOnTouch: false,
//                     front: LoginForm(flipkey: _flipKey),
//                     back: SignupForm(flipkey: _flipKey))
//               ],
//             ),
//           ),
//         )),
//       ),
//     );
//   }
// }
