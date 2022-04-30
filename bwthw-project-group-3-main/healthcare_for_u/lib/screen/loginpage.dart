import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/screen/homepage.dart';
import 'package:healthcare_for_u/screen/signupform.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static const route = '/login';
  static const routename = 'Login Page';

  @override
  _LoginPageState createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _password = '';
  String _confirmPassword = '';

  void _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      Navigator.pushReplacementNamed(context, HomePage.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 92, 171, 235),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text(
              'Login', // potenzialmente spostare nell'appBar
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
                          /// Eamil
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
                              onPressed: _trySubmitForm,
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
                              Navigator.pushNamed(context, SignUpForm.route);
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
