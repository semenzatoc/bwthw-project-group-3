import 'package:healthcare_for_u/models/risklevel.dart';
import 'package:healthcare_for_u/repository/databaseRepository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
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
  List<FormElement> _diabetesAnswers = [];
  //final gender = "F";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FINnish Diabetes RIsk SCore \n (FINDRISC)'),
          //centerTitle: true
        ),
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
                                _diabetesAnswers =
                                    _key.currentState!.getElementList();
                                _saveDiabetes(_diabetesAnswers, context);
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
                                            body: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FutureBuilder(
                                                    future: fetcher
                                                        .calcMonthActivity(
                                                            context),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
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
                                                            RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                      'Your total risk score is: ',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "$riskValue",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    )
                                                                  ]),
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                            _gradientProgress(
                                                                riskValue),
                                                            const SizedBox(
                                                                height: 20),
                                                            _textResult(
                                                                riskValue,
                                                                riskLevel),
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
                      'Not enough data available'); // if the user did not take the signup form
                }
              }),
        ));
  }
} //HealthPage

void _saveDiabetes(List<FormElement> _diabetesAnswers, context) async {
  var sp = await SharedPreferences.getInstance();
  final questionList2 = [
    'weight',
    'height',
    'waist',
    'veg',
    'med',
    'glu',
    'diab'
  ];
  for (var i = 0; i < _diabetesAnswers.length; i++) {
    if (_diabetesAnswers[i].answer == '') {
    } else {
      sp.setString(questionList2[i], _diabetesAnswers[i].answer);
    }
  }
  await Provider.of<DatabaseRepository>(context, listen: false)
      .updateWeight(sp.getInt('usercode')!, sp.getString('weight')!);
  await Provider.of<DatabaseRepository>(context, listen: false)
      .updateHeight(sp.getInt('usercode')!, sp.getString('height')!);
} //_saveDiabetes

Widget _gradientProgress(int riskValue) {
  return Stack(alignment: AlignmentDirectional.centerStart, children: [
    const StepProgressIndicator(
      totalSteps: 26,
      currentStep: 0,
      direction: Axis.horizontal,
      size: 40,
      padding: 0,
      unselectedColor: Colors.black,
      roundedEdges: Radius.circular(10),
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
      size: 41,
      padding: 0,
      selectedColor: Color.fromARGB(255, 8, 36, 44).withOpacity(0.0),
      unselectedColor: Colors.white,
      roundedEdges: const Radius.circular(10),
    ),
  ]);
}

Widget _textResult(int riskValue, RiskLevel riskLevel) {
  return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Your risk of developing type 2 diabetes within 10 years is \n",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        children: [
          TextSpan(
            text: "${riskLevel.title}",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: "\n which means that an ${riskLevel.description}",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ));
}

RiskLevel _getRiskLevel(int risk) {
  RiskLevel riskLevel = RiskLevel();
  if (risk < 7) {
    riskLevel.setTitle('LOW');
    riskLevel.setDescription('estimated 1 in 100 will develop diabetes.');
  } else if (risk >= 7 && risk <= 11) {
    riskLevel.setTitle('SLIGHTLY ELEVATED');
    riskLevel.setDescription('estimated 1 in 25 will develop diabetes.');
  } else if (risk >= 12 && risk <= 14) {
    riskLevel.setTitle('MODERATE');
    riskLevel.setDescription('estimated 1 in 6 will develop diabetes.');
  } else if (risk >= 15 && risk <= 20) {
    riskLevel.setTitle('HIGH');
    riskLevel.setDescription('estimated 1 in 3 will develop diabetes.');
  } else {
    riskLevel.setTitle('VERY HIGH');
    riskLevel.setDescription('estimated one in 1 will develop diabetes.');
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
