import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/screen/authpage.dart';
import 'package:healthcare_for_u/screen/homepage.dart';
import 'package:healthcare_for_u/screen/signupform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_for_u/database/entities/user.dart';
import 'package:healthcare_for_u/repository/databaseRepository.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static const route = '/';
  static const routename = 'Login Page';

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _password = '';
  String _confirmPassword = '';
  int _user_id = 0;
  bool incorrectUsername = false;

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

  void _trySubmitForm(String _username) async {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      final sp = await SharedPreferences.getInstance();
      sp.setString('username', _username);
      sp.setInt('usercode', _user_id);
      List<User> allUsers =
          await Provider.of<DatabaseRepository>(context, listen: false)
              .findAllUsers();
      User loggedUser =
          allUsers.firstWhere((user) => user.username == _userName);
      sp.setString('name', loggedUser.name);
      sp.setString('gender', loggedUser.gender);
      sp.setString('dob', loggedUser.dob);
      sp.setString('weight', loggedUser.weight);
      sp.setString('height', loggedUser.height);
      sp.setString('goal', loggedUser.goal.toString());
      sp.setString('profilepicture', loggedUser.profilepicture);

      Navigator.pushReplacementNamed(context, AuthPage.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 92, 171, 235),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: Provider.of<DatabaseRepository>(context, listen: false)
                  .findAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userList = snapshot.data as List<User>;
                  return Column(children: [
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
                                          TextFormField(
                                              decoration: const InputDecoration(
                                                  labelText: 'Username'),
                                              validator: (value) {
                                                try {
                                                  _userName = userList
                                                      .firstWhere((user) =>
                                                          user.username ==
                                                          value)
                                                      .username;
                                                } on StateError catch (exception) {
                                                  setState(() {
                                                    incorrectUsername = true;
                                                  });
                                                }
                                                if (incorrectUsername) {
                                                  return 'Username does not exist';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onChanged: (value) {
                                                _userName = value;
                                              }),

                                          /// Password
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                labelText: 'Password'),
                                            obscureText: true,
                                            validator: (value) {
                                              try {
                                                _password = userList
                                                    .firstWhere((user) =>
                                                        user.username ==
                                                        _userName)
                                                    .password;
                                              } on StateError catch (e) {
                                                return 'Wrong password';
                                              }
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return 'This field is required';
                                              } else {
                                                if (value == _password) {
                                                  _user_id = userList
                                                      .firstWhere((user) =>
                                                          user.username ==
                                                          _userName)
                                                      .id!;
                                                  return null;
                                                } else {
                                                  return 'Wrong password';
                                                }
                                              }
                                            },
                                            onChanged: (value) =>
                                                _password = value,
                                          ),
                                          const SizedBox(height: 20),
                                          OutlinedButton(
                                              onPressed: () {
                                                _trySubmitForm(_userName);
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
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            SignUpForm.route);
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
                                        ])))))
                  ]);
                } else {
                  return LinearProgressIndicator();
                }
              }),
        ));
  }
}//Login Page