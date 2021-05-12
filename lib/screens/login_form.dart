// import 'package:flip_card/flip_card.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_app/widgets/custom_textfield.dart';


// class LoginForm extends StatefulWidget {
//   final GlobalKey<FlipCardState> flipkey;
//   const LoginForm({Key key, @required this.flipkey}) : super(key: key);
//   @override
//   _LoginFormState createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _formKey = GlobalKey<FormState>();
//   bool _loading = false, _showPassword = false;
//   AutovalidateMode _autovalidate = AutovalidateMode.disabled;
//   TextEditingController _emailController, _passwordController;
//   // String _email, _password;

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: AbsorbPointer(
//         absorbing: _loading,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           width: MediaQuery.of(context).size.width,
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               autovalidateMode: _autovalidate,
//               child: Column(
//                 children: [
//                   Text(
//                     'Login',
//                     style: TextStyle(fontSize: 30, color: Colors.blue),
//                   ),
//                   RoundedTextField(
//                     child: TextFormField(
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: roundedTFDecoration(
//                           hintText: 'Email', prefixIcon: Icons.mail_outline),
//                       validator: (value) {
//                         if (value.trim().isEmpty)
//                           return 'Please Enter Email';
//                         else if (!value.trim().contains('@'))
//                           return 'Invalid Email';
//                         return null;
//                       },
//                     ),
//                   ),
//                   RoundedTextField(
//                     child: TextFormField(
//                       controller: _passwordController,
//                       keyboardType: TextInputType.text,
//                       obscureText: !_showPassword,
//                       decoration: roundedTFDecoration(
//                           hintText: 'Password',
//                           prefixIcon: Icons.lock_outline,
//                           suffixAction: () =>
//                               setState(() => _showPassword = !_showPassword),
//                           suffixIcon: _showPassword
//                               ? Icons.visibility_off
//                               : Icons.visibility),
//                       validator: (value) {
//                         if (value.trim().isEmpty)
//                           return 'Please Enter Password';
//                         else if (value.trim().length < 6)
//                           return 'Minimum 6 characters';
//                         return null;
//                       },
//                     ),
//                   ),
//                   _loading
//                       ? Column(
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 20.0),
//                               child: CircularProgressIndicator(),
//                             ),
//                             Text(
//                               'Logging you in...',
//                               style: TextStyle(color: Colors.blue),
//                             )
//                           ],
//                         )
//                       : Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             GestureDetector(
//                               // onTap: () => Navigator.of(context)
//                               //     .push(goTo(ForgotPassword())),
//                               child: Padding(
//                                 padding: const EdgeInsets.only(top: 15.0),
//                                 child: Text(
//                                   'Forgot Password ?',
//                                   style:
//                                       TextStyle(fontSize: 18, color: Colors.blue),
//                                 ),
//                               ),
//                             ),
//                             MyButton(
//                                 title: 'Login',
//                                 action: () {
//                                   if (_formKey.currentState.validate())
//                                     _handleLogin();
//                                   else
//                                     setState(() => _autovalidate =
//                                         AutovalidateMode.onUserInteraction);
//                                 }),
                            
//                             GestureDetector(
//                               onTap: () =>
//                                   widget.flipkey.currentState.toggleCard(),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   RichText(
//                                     text: TextSpan(
//                                         text: 'Don\'t have an Account ? ',
//                                         style: TextStyle(
//                                             fontSize: 15, color: Colors.black),
//                                         children: [
//                                           TextSpan(
//                                               text: 'Sign Up',
//                                               style: TextStyle(
//                                                   fontSize: 17, color: Colors.blue))
//                                         ]),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _handleLogin({bool isGoogle = false}) async {
//     FocusScope.of(context).unfocus();
//     setState(() => _loading = true);
//     Map result = isGoogle
//         ? await AuthService().googleSignIn()
//         : await AuthService()
//             .sigIn(_emailController.text, _passwordController.text);
//     await Future.delayed(Duration(seconds: 1));
//     setState(() => _loading = false);
//     bool success = result['success'];
//     String title = success ? 'Login Successful' : 'Error';
//     String content = success ? null : result['msg'];
//     CurrentUser currentUser;
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => WillPopScope(
//               onWillPop: () => Future.value(!success),
//               child: DialogBox(
//                   title: title,
//                   titleColor: !success ? Colors.red : null,
//                   icon: success ? Icons.verified_user : null,
//                   iconColor: Colors.teal,
//                   description: content,
//                   buttonText1: !success ? 'OK' : null,
//                   button1Func: !success
//                       ? () => Navigator.of(context, rootNavigator: true).pop()
//                       : null),
//             ));
//     if (success) {
//       await Future.delayed(Duration(seconds: 2));
//       currentUser = result['current'];
//       Navigator.of(context, rootNavigator: true).pop();
//       Navigator.of(context).pushReplacement(
//         goTo(
//           MultiProvider(providers: [
//             ChangeNotifierProvider<CurrentUser>.value(value: currentUser),
//             ChangeNotifierProvider<Cart>.value(value: currentUser.cart),
//                 ChangeNotifierProvider<Menu>.value(value: Menu.menu),
//           ], child: MainScreen()),
//         ),
//       );
//     }
//   }
// }
