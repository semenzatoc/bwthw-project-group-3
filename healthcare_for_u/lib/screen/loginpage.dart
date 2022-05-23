import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/models/login.dart';
import 'package:healthcare_for_u/screen/homepage.dart';
import 'package:healthcare_for_u/screen/signupform.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static const route = '/login';
  static const routename = 'Login Page';

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  void initState() {
    super.initState();
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
  } //initState

  void _checkLogin() async {
    //Get the SharedPreference instance and check if the value of the 'username' filed is set or not
    final sp = await SharedPreferences.getInstance();
    if (sp.getString('username') != null) {
      //If 'username is set, push the HomePage
      Navigator.pushReplacementNamed(context, HomePage.route);
    } //if
  } //_checkLogin

  /* Future<String> _loginUser(LoginCouples data) async {
    if (data.username == 'user' && data.password == '12345') {
      final sp = await SharedPreferences.getInstance();
      sp.setString('username', data.username!);

      return '';
    } else {
      return 'Wrong credentials';
    }
  }*/

  void _trySubmitForm(LoginCouples data) async {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      final sp = await SharedPreferences.getInstance();
      sp.setString('username', data.username!);

      Navigator.pushReplacementNamed(context, HomePage.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginCouples logData;
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 92, 171, 235),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text(
              'Login',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 5,
                  fontSize: 35,
                  color: Colors.white),
            ),
            Center(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Email
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (value != 'user') {
                                return 'Wrong Email';
                              }
                              // Check if the entered email has the right format
                              if (value == 'user') {
                                return null;
                              }
                            },
                            onChanged: (value) => _userEmail = value,
                          ),

                          /// Password
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required';
                              }
                              if (value != '12345') {
                                return 'Wrong Password';
                              }
                              if (value == '12345') {
                                return null;
                              }
                            },
                            onChanged: (value) => _password = value,
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                              onPressed: () {
                                logData = LoginCouples(
                                    username: _userEmail, password: _password);
                                _trySubmitForm(logData);
                              },
                              child: const Text('Sign In')),
                          const SizedBox(height: 20),

                          RichText(
                              text: TextSpan(
                            text: "Don't have an account?",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: " Sign up",
                                style: const TextStyle(
                                  color: Colors.purple,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, SignUpForm.route);
                                  },
                              ),
                              const TextSpan(
                                text: " today!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} //Login Page
