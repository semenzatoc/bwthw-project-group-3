import 'package:healthcare_for_u/models/risklevel.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:healthcare_for_u/utils/appcredentials.dart';
import 'package:healthcare_for_u/utils/diabetesRisk.dart';
import 'package:healthcare_for_u/utils/fetchMonthActivity.dart';
import 'package:conditional_questions/conditional_questions.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
            title: Text('FINnish Diabetes RIsk SCore \n(FINDRISC)'),
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
                  final sp = snapshot.data as SharedPreferences;
                  final gender = sp.getString('gender');
                  return ConditionalQuestions(
                      key: _key,
                      children: questions(gender),
                      trailing: [
                        MaterialButton(
                            child: Text("Discover your risk score!"),
                            color: Colors.blue,
                            splashColor: Colors.lightBlue,
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          alignment: Alignment.center,
                                          title: Text('Total risk score',
                                              textAlign: TextAlign.center),
                                          content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                FutureBuilder(
                                                    future:
                                                        _calcMonthActivity(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        diabetes_list = _key
                                                            .currentState!
                                                            .getElementList();
                                                        _saveDiabetes(
                                                            diabetes_list);
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
                                                        return Column(
                                                          children: [
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                                'Your total risk score is:'
                                                                '$riskValue!',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            SizedBox(
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
                                                        return CircularProgressIndicator();
                                                      }
                                                    })
                                              ]),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Close'),
                                            ),
                                          ],
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
                  return Text(
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
}

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
        // not mandattory
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
}

Future<List<FitbitActivityTimeseriesData>> _fetchMonthActivity(
    String dataType) async {
  FitbitActivityTimeseriesDataManager fitbitVeryActiveTimeseriesDataManager =
      FitbitActivityTimeseriesDataManager(
          clientID: AppCredentials.fitbitClientID,
          clientSecret: AppCredentials.fitbitClientSecret,
          type: dataType);

  final durationActivity = await fitbitVeryActiveTimeseriesDataManager
      .fetch(FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    userID: '7ML2XV',
    startDate:
        DateTime.now().subtract(Duration(days: 30)), //fetching 30 days ago
    endDate:
        DateTime.now().subtract(Duration(days: 1)), //fetching until yesterday
    resource: fitbitVeryActiveTimeseriesDataManager.type,
  )) as List<FitbitActivityTimeseriesData>;
  return durationActivity;
}

Future<bool> _calcMonthActivity() async {
  //Minutes very active in the past month
  final durationVeryActive = await _fetchMonthActivity('minutesVeryActive');
  //Minutes fairly active in the past month
  final durationFairlyActive = await _fetchMonthActivity('minutesFairlyActive');
  //Classified as active if minimum of 30 minutes activity in more than 50% of
  //days in the past month
  double minDailyActive = 0;
  int countActiveDays = 0;

  for (var i = 0; i < 30; i++) {
    minDailyActive = minDailyActive +
        (durationVeryActive[i].value as double) +
        (durationFairlyActive[i].value as double);

    if (minDailyActive > 30) {
      countActiveDays = countActiveDays + 1;
    }
  } // for
  bool activity = false;
  if (countActiveDays / 30 > 0.5) {
    activity = true;
  }
  return activity;
}
