import 'package:flutter/material.dart';
import 'homepage.dart';
import 'loginpage.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Aggiungere popup menu button/bottom sheet per logout/edit/delete
// Riportare informazioni personali: Nome/età/peso/altezza/bmi/etc
class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  static const route = '/profile';
  static const routename = 'Profile Page';

  @override
  Widget build(BuildContext context) {
    print('${ProfilePage.routename} built');
    return Scaffold(
      appBar: AppBar(
          title: Text(ProfilePage.routename),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, LoginPage.route,
                      (Route<dynamic> route) => false);
                },
                icon: Icon(Icons.logout))
          ]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Home',
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HomePage.route);
              },
            ),
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Hello, world!'),
      ),
    );
  } //build

} //ProfilePage