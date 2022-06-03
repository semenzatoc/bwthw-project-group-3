import 'package:flutter/material.dart';
import 'package:healthcare_for_u/screen/healthpage.dart';
import 'package:healthcare_for_u/screen/userpage.dart';
import 'screen/loginpage.dart';
import 'screen/homepage.dart';
import 'screen/profilepage.dart';
import 'screen/signupform.dart';
import 'screen/healthpage.dart';
import 'screen/calendarpage.dart';
import 'screen/authpage.dart';

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
        LoginPage.route: (context) => LoginPage(),
        AuthPage.route: (context) => AuthPage(),
        HomePage.route: (context) => HomePage(),
        ProfilePage.route: (context) => ProfilePage(),
        SignUpForm.route: (context) => SignUpForm(),
        UserPage.route:(context) => UserPage(),
        CalendarPage.route: (context) => CalendarPage(),
        HealthPage.route: (context) => HealthPage(),
      },
    );
  } //build
}//MyApp