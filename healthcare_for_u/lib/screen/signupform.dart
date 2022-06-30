import 'package:flutter/material.dart';
import 'package:conditional_questions/conditional_questions.dart';
import 'package:healthcare_for_u/screen/userpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  static const route = '/signup';
  static const routename = 'Sign Up Page';

  @override
  _SignUpFormState createState() {
    return _SignUpFormState();
  }
}

class _SignUpFormState extends State<SignUpForm> {
  final _key = GlobalKey<QuestionFormState>();
  List<FormElement> answerList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Form'),
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
                answerList = _key.currentState!.getElementList();
                saveAnswers(answerList);
                Navigator.pushNamed(context, UserPage.route);
              }
            },
            child: const Text("Next"),
          )
        ],
      ),
    );
  }
}

//Future<SharedPreferences>
void saveAnswers(List<FormElement> answerList) async {
  final sp = await SharedPreferences.getInstance();
  final questionList = ['name', 'gender', 'dob', 'weight', 'height', 'goal'];
  for (var i = 0; i < answerList.length; i++) {
    sp.setString(questionList[i], answerList[i].answer);
  }
  sp.setString('lastUpdate', '2022-03-01');
  sp.setString('imagepath', '');
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
        question: "What's your sex?", answers: ["F", "M"], isMandatory: true),
    Question(
      question: "What's your date of birth (dd/mm/yyyy)",

      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
    Question(
      question: "What's your weight in kg?",
      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
    Question(
      question: "What's your heigth in cm?",
      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
    Question(
      question: "What's your daily step goal?",
      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
  ];
}
