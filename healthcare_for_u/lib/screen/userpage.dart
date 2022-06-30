import 'package:flutter/material.dart';
import 'package:conditional_questions/conditional_questions.dart';
import 'package:healthcare_for_u/database/entities/user.dart';
import 'package:healthcare_for_u/repository/databaseRepository.dart';
import 'package:healthcare_for_u/screen/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  static const route = '/userpage';
  static const routename = 'UserPage';

  @override
  _UserPageState createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  bool isRegistered = true;
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Sign Up'),
        ),
        body: Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: FutureBuilder(
                    future:
                        Provider.of<DatabaseRepository>(context, listen: false)
                            .findAllUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userList = snapshot.data as List<User>;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Username
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Select your Username'),
                              validator: (value) {
                                try {
                                  _username = userList
                                      .firstWhere(
                                          (user) => user.username == value)
                                      .username;
                                } on StateError catch (exception) {
                                  //If exception is thrown username isn't already
                                  // used in the DB and can be selected
                                  setState(() {
                                    isRegistered = false;
                                  });
                                }
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your username';
                                } else if (isRegistered) {
                                  return 'Username already exists. Please choose another';
                                } else {
                                  _username = value;
                                  return null;
                                }
                              },
                              onChanged: (value) => _username = value,
                            ),
                            const SizedBox(height: 20),
                            // Password
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Select your Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required';
                                } else {
                                  _password = value;
                                  return null;
                                }
                              },
                              onChanged: (value) => _password = value,
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton(
                                onPressed: () {
                                  _trySubmit(_username, _password);
                                },
                                child: const Text('Submit')),
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ),
            ),
          ),
        ));
  } // Userpage

  void _trySubmit(String? _username, String? _password) async {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      var sp = await SharedPreferences.getInstance();
      String? name = sp.getString('name');
      String? gender = sp.getString('gender');
      String? weight = sp.getString('weight');
      String? height = sp.getString('height');
      String? dob = sp.getString('dob');
      int? goal = int.parse(sp.getString('goal')!);
      String? picture = sp.getString('imagepath');
      String? lastUpdate = sp.getString('lastUpdate');
      await Provider.of<DatabaseRepository>(context, listen: false).insertUser(
          User(null, _username!, _password!, name!, gender!, weight!, height!,
              dob!, goal, picture!, lastUpdate!));
      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.route, (Route<dynamic> route) => false);
    }
  } //_trySubmitForm
} // _UserPageState
