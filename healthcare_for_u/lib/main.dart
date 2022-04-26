import 'package:flutter/material.dart';
import 'screen/loginpage.dart';
import 'screen/homepage.dart';
import 'screen/profilepage.dart';
import 'screen/signupform.dart';

void main() {
  runApp(MyApp());
} //main

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData(colorScheme: Colors.green),
      initialRoute: LoginPage.route,
      routes: {
        HomePage.route: (context) => HomePage(),
        LoginPage.route: (context) => LoginPage(),
        ProfilePage.route: (context) => ProfilePage(),
        SignUpForm.route: (context) => SignUpForm(),
      },
    );
  } //build
}//MyApp