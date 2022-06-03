import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_for_u/screen/healthpage.dart';
import 'package:healthcare_for_u/screen/userpage.dart';
import 'screen/loginpage.dart';
import 'screen/homepage.dart';
import 'screen/profilepage.dart';
import 'screen/signupform.dart';
import 'screen/healthpage.dart';
import 'screen/calendarpage.dart';
import 'screen/authpage.dart';
import 'package:healthcare_for_u/database/database.dart';
import 'package:healthcare_for_u/repository/databaseRepository.dart';

Future<void> main() async {
  //This is a special method that use WidgetFlutterBinding to interact with the Flutter engine.
  //This is needed when you need to interact with the native core of the app.
  //Here, we need it since when need to initialize the DB before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  //This opens the database.
  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);

  //Here, we run the app and we provide to the whole widget tree the instance of the DatabaseRepository.
  //That instance will be then shared through the platform and will be unique.
  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: MyApp(),
  ));
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
        UserPage.route: (context) => UserPage(),
        CalendarPage.route: (context) => CalendarPage(),
        HealthPage.route: (context) => HealthPage(),
      },
    );
  } //build
} //MyApp
