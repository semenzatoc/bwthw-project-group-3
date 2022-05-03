import 'package:flutter/material.dart';
import 'package:conditional_questions/conditional_questions.dart';
import 'package:healthcare_for_u/screen/loginpage.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';

//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  static const route = '/signup';
  static const routename = 'Sign Up Page';

  @override
  _SignUpFormState createState() {
    // TODO: implement createState
    return _SignUpFormState();
  }
}

class _SignUpFormState extends State<SignUpForm> {
  final _key = GlobalKey<QuestionFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Form'),
      ),
      body: ConditionalQuestions(
        key: _key,
        children: questions(),
        trailing: [
          MaterialButton(
            color: Colors.blue,
            splashColor: Colors.lightBlue,
            onPressed: () async {
              if (_key.currentState!.validate()) {
                Navigator.pushNamed(context, LoginPage.route);
              }
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
//Chiedere come salvare le risposte che vengono inserite

List<Question> questions() {
  return [
    Question(
      question: "What is your name?",
      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
    PolarQuestion(
        question: "What's your gender?",
        answers: ["F", "M", 'Unspecified'],
        isMandatory: true),
    Question(
      question: "What's your date of birth (dd/mm/yyyy)",

      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
    Question(
      question: "What's your weight?",
      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
    Question(
      question: "What's your heigth?",
      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
  ];
}
