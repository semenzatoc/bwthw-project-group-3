import 'package:flutter/material.dart';
import 'package:conditional_questions/conditional_questions.dart';
import 'package:healthcare_for_u/screen/loginpage.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:healthcare_for_u/screen/userpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<FormElement> answer_list = [];

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
                answer_list = _key.currentState!.getElementList();
                final sp = await SharedPreferences.getInstance();
                sp.setString('imagepath', '');
                saveAnswers(answer_list);
                Navigator.pushNamed(context, UserPage.route);
              }
            },
            child: Text("Next"),
          )
        ],
      ),
    );
  }
}

//Future<SharedPreferences>
void saveAnswers(List<FormElement> answer_list) async {
  final sp = await SharedPreferences.getInstance();
  final questionList = ['name', 'gender', 'dob', 'weight', 'height','goal'];
  for (var i = 0; i < answer_list.length; i++) {
    sp.setString(questionList[i], answer_list[i].answer);
  }
  //return sp;
}

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
        question: "What's your sex?",
        answers: ["F", "M"],
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
     Question(
      question: "What's your steps goal?",
      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
  ];
}
