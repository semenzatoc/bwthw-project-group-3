import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/models/login.dart';
import 'package:healthcare_for_u/screen/homepage.dart';
import 'package:healthcare_for_u/screen/signupform.dart';
import 'package:healthcare_for_u/utils/appcredentials.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  static const route = '/auth';
  static const routename = 'Authorization Page';

  @override
  _AuthPageState createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Authorization Page'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Are you connected to FitBit?'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Authorize the app
                String? userId = await FitbitConnector.authorize(
                    context: context,
                    clientID: AppCredentials.fitbitClientID,
                    clientSecret: AppCredentials.fitbitClientSecret,
                    redirectUri: AppCredentials.fitbitRedirectUri,
                    callbackUrlScheme: AppCredentials.fitbitCallbackScheme);
                Navigator.pushReplacementNamed(context, HomePage.route);
              },
              child: const Text('Tap to authorize'),
            ),
          ],
        ),
      ),
    );
  }
} //Login Page
