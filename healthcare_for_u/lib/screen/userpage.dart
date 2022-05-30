import 'package:flutter/material.dart';
import 'package:conditional_questions/conditional_questions.dart';
import 'package:healthcare_for_u/screen/loginpage.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  static const route = '/userpage';
  static const routename = 'UserPage';

  @override
  _UserPageState createState() {
    // TODO: implement createState
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  final _key = GlobalKey<QuestionFormState>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
      ),
      body: Center(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: _key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // User
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'User'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your username';
                              } else { 
                                _saveUser(value);
                              }} ),
                              const SizedBox(height: 20),
                          // Password
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required';
                              } else {
                                _savePassword(value);
                              }},
                          ),
                          const SizedBox(height: 20),
                          // Repeat the password
                         // TextFormField(
                           //decoration:
                             //   const InputDecoration(labelText: 'Repeat Password'),
                            //obscureText: true,
                            //validator: (value) {
                             // if (value == null || value.trim().isEmpty) {
                              // return 'This field is required';
                              //}; 
                              //var check = _checkPassword(value);
                              //if (check == 'wrong') {
                               //return 'Passwords don\'t match';
                             //}}
                         //),

                          OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, LoginPage.route);
                              },
                              child: const Text('Submit')),
    ],),),),),),);
  }
}

//Future<SharedPreferences>
void _saveUser(String user) async {
  final sp = await SharedPreferences.getInstance();
  sp.setString('user', user);
  //return sp;
}

void _savePassword(String password) async {
  final sp = await SharedPreferences.getInstance();
  sp.setString('password', password);
  //return sp;
}

//Future<String?> _checkPassword(String value) async {
//  final sp = await SharedPreferences.getInstance();
 // if (sp.getString('password') != value) {
 //   return 'wrong';
 //}
 // return 'wrong';
 //return sp;
//}