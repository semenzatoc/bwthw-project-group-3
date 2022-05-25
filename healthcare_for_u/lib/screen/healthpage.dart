import 'package:healthcare_for_u/models/risklevel.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:healthcare_for_u/utils/appcredentials.dart';
import 'package:healthcare_for_u/utils/diabetesRisk.dart';
import 'package:healthcare_for_u/utils/dataFetcher.dart';
import 'package:conditional_questions/conditional_questions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:xen_popup_card/xen_card.dart';
import 'homepage.dart';
import 'calendarpage.dart';

class HealthPage extends StatefulWidget {
  HealthPage({Key? key}) : super(key: key);

  static const route = '/health';
  static const routename = 'Health Status Page';

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final _key = GlobalKey<QuestionFormState>();
  List<FormElement> diabetes_list = [];
  //final gender = "F";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('FINnish Diabetes RIsk SCore \n(FINDRISC)'),
            centerTitle: true),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                tooltip: 'Calendar',
                icon: const Icon(Icons.calendar_month),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, CalendarPage.route);
                },
              ),
              IconButton(
                tooltip: 'Home',
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, HomePage.route);
                },
              ),
              IconButton(
                tooltip: 'Check your health status',
                icon: const Icon(MdiIcons.heartFlash),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'Profile',
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, ProfilePage.route);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var sp = snapshot.data as SharedPreferences;
                  final gender = sp.getString('gender');
                  return ConditionalQuestions(
                      key: _key,
                      children: questions(gender),
                      trailing: [
                        MaterialButton(
                            child: const Text("Discover your risk score!"),
                            color: Colors.blue,
                            splashColor: Colors.lightBlue,
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                diabetes_list =
                                    _key.currentState!.getElementList();
                                _saveDiabetes(diabetes_list);
                                sp = await SharedPreferences.getInstance();
                                DataFetcher fetcher = DataFetcher();
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 80),
                                          child: XenPopupCard(
                                            appBar: const XenCardAppBar(
                                                child: Text(
                                              'Total Risk Score',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                            //gutter: gutter,
                                            body: Column(
                                              children: [
                                                FutureBuilder(
                                                    future: fetcher
                                                        .calcMonthActivity(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        /*bool physicalActivity =
                                          await _calcMonthActivity();*/
                                                        int riskValue =
                                                            diabetesRisk(
                                                                sp,
                                                                gender,
                                                                snapshot);
                                                        final riskLevel =
                                                            _getRiskLevel(
                                                                riskValue);
                                                        sp.setInt(
                                                            'risk', riskValue);
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                                'Your total risk score is:'
                                                                '$riskValue!',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            SizedBox(
                                                                height: 20),
                                                            GradientProgress(
                                                                riskValue),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                                'The risk of developing type'
                                                                ' 2 diabetes within 10 years'
                                                                ' is classified as '
                                                                '${riskLevel.title} = '
                                                                '${riskLevel.description}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ],
                                                        );
                                                      } else {
                                                        return const LinearProgressIndicator();
                                                      }
                                                    })
                                              ],
                                            ),
                                          ),
                                        ));
                              }
                            })
                      ],
                      leading: const [
                        Text(
                            "Complete the type 2 diabetes risk assessment form",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 3,
                                fontSize: 15,
                                color: Colors.blue))
                      ]);
                } else {
                  return const Text(
                      'Not enough data available'); // se non ho fatto il sign up form
                }
              }),
        ));
  }
} //HealthPage

void _saveDiabetes(List<FormElement> diabetes_list) async {
  final sp = await SharedPreferences.getInstance();
  final questionList2 = [
    'weight',
    'height',
    'waist',
    'veg',
    'med',
    'glu',
    'diab'
  ];
  for (var i = 0; i < diabetes_list.length; i++) {
    if (diabetes_list[i].answer == '') {
    } else {
      sp.setString(questionList2[i], diabetes_list[i].answer);
    }
  }
} //_saveDiabetes

Widget GradientProgress(int riskValue) {
  return Stack(alignment: AlignmentDirectional.centerStart, children: [
    const StepProgressIndicator(
      totalSteps: 26,
      currentStep: 0,
      direction: Axis.horizontal,
      size: 20,
      padding: 0,
      //selectedColor: Color.fromARGB(255, 59, 213, 255).withOpacity(0.2),
      unselectedColor: Colors.black,
      roundedEdges: Radius.circular(10),
      /* selectedGradientColor: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.green, Colors.yellow, Colors.red],
      ),*/
      unselectedGradientColor: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.green, Colors.yellow, Colors.red],
      ),
    ),
    StepProgressIndicator(
      totalSteps: 26,
      currentStep: riskValue,
      direction: Axis.horizontal,
      size: 21,
      padding: 0,
      //progressDirection: TextDirection.RTL,
      selectedColor: Color.fromARGB(255, 8, 36, 44).withOpacity(0.0),
      unselectedColor: Colors.white,
      roundedEdges: const Radius.circular(10),
      /* selectedGradientColor: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.green, Colors.yellow, Colors.red],
      ),*/
      /*unselectedGradientColor: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.green, Colors.yellow, Colors.red],
      ),*/
    ),
  ]);
}

RiskLevel _getRiskLevel(int risk) {
  RiskLevel riskLevel = RiskLevel();
  if (risk < 7) {
    riskLevel.setTitle('LOW');
    riskLevel.setDescription('estimated 1 in 100 will develop disease');
  } else if (risk >= 7 && risk <= 11) {
    riskLevel.setTitle('SLIGHTLY ELEVATED');
    riskLevel.setDescription('estimated 1 in 25 will develop disease');
  } else if (risk >= 12 && risk <= 14) {
    riskLevel.setTitle('MODERATE');
    riskLevel.setDescription('estimated 1 in 6 will develop disease');
  } else if (risk >= 15 && risk <= 20) {
    riskLevel.setTitle('HIGH');
    riskLevel.setDescription('estimated 1 in 3 will develop disease');
  } else {
    riskLevel.setTitle('VERY HIGH');
    riskLevel.setDescription('estimated one in 1 will develop disease');
  }
  return riskLevel;
} //RiskLevel

List<Question> questions(gender) {
  if (gender == 'F') {
    return [
      Question(
        question: "If changed, update your current weight!",
        // not mandatory
      ),
      Question(
        question: "If changed, update your current height!",
        // not mandattory
      ),
      PolarQuestion(
          question: "Waist circumference measured below the ribs",
          answers: ["Less than 80 cm", "80-88 cm", 'More than 88 cm'],
          isMandatory: true),
      PolarQuestion(
          question: "How often do you eat vegetables, fruit or berries?",
          answers: ["Everyday", "Not everyday"],
          isMandatory: true),
      PolarQuestion(
          question: "Have you ever taken antihypertensive?",
          answers: ["Yes", "No"],
          isMandatory: true),
      PolarQuestion(
          question: "Have you ever been found to have high blood glucose?",
          answers: ["Yes", "No"],
          isMandatory: true),
      PolarQuestion(
          question:
              "Have any of the members of your immediate family or other relatives been diagnosed with diabetes (type1 or type 2)?",
          answers: [
            "No",
            "Yes: grandparent, aunt, uncle or first cousin",
            "Yes: parent, brother, sister or own child"
          ],
          isMandatory: true)
    ];
  } else {
    return [
      Question(
        question: "If changed, update your current weight!",
        // not mandatory
      ),
      Question(
        question: "If changed, update your current height!",
        // not mandatory
      ),
      PolarQuestion(
          question: "Waist circumference measured below the rist",
          answers: ["Less than 94 cm", "94-102 cm", "More than 102 cm"],
          isMandatory: true),
      PolarQuestion(
          question: "How often do you eat vegetables, fruit or berries?",
          answers: ["Everyday", "Not everyday"],
          isMandatory: true),
      PolarQuestion(
          question: "Have you ever taken antihypertensive?",
          answers: ["Yes", "No"],
          isMandatory: true),
      PolarQuestion(
          question: "Have you ever been found to have high blood glucose?",
          answers: ["Yes", "No"],
          isMandatory: true),
      PolarQuestion(
          question: "Have any of the members of your immediate family or other"
              " relatives been diagnosed with diabetes (type1 or type 2)?",
          answers: [
            "No",
            "Yes: grandparent, aunt, uncle or first cousin",
            "Yes: parent, brother, sister or own child"
          ],
          isMandatory: true)
    ];
  }
}//questions
