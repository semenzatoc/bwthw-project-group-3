import 'package:flutter/material.dart';
import 'package:healthcare_for_u/screen/homepage.dart';
import 'package:healthcare_for_u/screen/signupform.dart';

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
                              onPressed: _trySubmitForm,
                              child: const Text('Sign In')),
                          const SizedBox(height: 20),
                          Text('If you aren\'t registered, sign up today!'),
                          const SizedBox(height: 20),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, SignUpForm.route);
                              },
                              child: const Text('Sign Up')),
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
