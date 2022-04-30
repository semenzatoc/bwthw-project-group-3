import 'package:flutter/material.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({Key? key}) : super(key: key);

  static const route = '/signup';
  static const routename = 'Sign Up Page';

// Inserire form di sondaggio per l'iscrizione
// username e password, informazioni personali, informazioni sull'attività
// possibile fare il form in più pagine, con passggio "Next"
  @override
  Widget build(BuildContext context) {
    print('${SignUpForm.routename} built');
    return Scaffold(
      appBar: AppBar(title: Text(SignUpForm.routename), centerTitle: true),
      body: Center(
        child: Text('Hello, world!'),
      ),
    );
  } //build

} //SignUpForm