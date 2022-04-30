import 'package:flutter/material.dart';
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
      ),
      body: Center(
        child: Text('Hello, world!'),
      ),
    );
  } //build

} //ProfilePage