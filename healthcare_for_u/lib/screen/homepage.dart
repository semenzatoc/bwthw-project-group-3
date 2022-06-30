import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/database/entities/activity.dart';
import 'package:healthcare_for_u/database/entities/user.dart';
import 'package:healthcare_for_u/repository/databaseRepository.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:healthcare_for_u/utils/getAchievement.dart';
import 'package:healthcare_for_u/screen/steppage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/appcredentials.dart';
import 'calendarpage.dart';
import 'caloriespage.dart';
import 'distancepage.dart';
import 'healthpage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static const route = '/home';
  static const routename = 'Home Page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    _getLastUpdate();
  } //initState

  void _getLastUpdate() async {
    final sp = await SharedPreferences.getInstance();
    // first access, set to 0
    if (sp.getInt('lastSteps') == null ||
        sp.getDouble('lastDistance') == null ||
        sp.getInt('lastCalories') == null) {
      sp.setInt('lastSteps', 0);
      sp.setDouble('lastDistance', 0);
      sp.setInt('lastCalories', 0);
    }

    // if lastFetch isn't today, do the first fetch of the day.
    // We can use the shared preference "lastUpdate" and check that it's yesterday.
    //If not, today there hasn't been any access yet and we need to fetch.
    DateTime lastFetch = DateTime.parse(sp.getString('lastUpdate')!)
        .add(const Duration(days: 1));
    DateTime today = DateTime.now();
    if (!isSameDay(today, lastFetch)) {
      await _updateCircles();
      print('First data fetch of the day completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(title: const Text('AmoebaFit'), centerTitle: true),
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
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Check your health status',
              icon: const Icon(MdiIcons.heartFlash),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HealthPage.route);
              },
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _updateCircles();
          print('Data fetched');
        },
        child: ListView(children: [
          _currentBadge(),
          const SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show circular progress indicator while filling any missing
              // DB activity entries if last update was before yesterday
              FutureBuilder(
                  future: _updateDB(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.done
                        ? const SizedBox()
                        : const CircularProgressIndicator();
                  }),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  child: _dataCircle('steps', MdiIcons.footPrint,
                      const Color.fromARGB(255, 242, 85, 28)),
                  onTap: () {
                    Navigator.pushNamed(context, StepPage.route);
                  },
                )
              ]),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      child: _dataCircle('calories', MdiIcons.fire,
                          const Color.fromARGB(255, 237, 80, 132)),
                      onTap: () {
                        Navigator.pushNamed(context, CaloriesPage.route);
                      }),
                  const SizedBox(width: 20),
                  InkWell(
                    child: _dataCircle('distance', MdiIcons.walk,
                        const Color.fromARGB(255, 61, 239, 159)),
                    onTap: () {
                      Navigator.pushNamed(context, DistancePage.route);
                    },
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  } // build

// function to fetch and update the last known values of today's steps, calories,
// and distance
  _updateCircles() async {
    final sp = await SharedPreferences.getInstance();
    int steps = await _fetchData('steps') as int;
    double distance = await _fetchData('distance') as double;
    int calories = await _fetchData('calories') as int;
    setState(() {
      sp.setInt('lastSteps', steps);
      sp.setDouble('lastDistance', distance);
      sp.setInt('lastCalories', calories);
    });
  } //_updateCircles

// function to fecth today's data knowing only the dataType
  Future<num> _fetchData(String dataType) async {
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: AppCredentials.fitbitClientID,
      clientSecret: AppCredentials.fitbitClientSecret,
      type: dataType,
    );

    final sp = await SharedPreferences.getInstance();

    dynamic data;

    //When login is automatic, but access token is expired we have to force a new
    // authorization to FitBit. This check is done with a try/catch block
    try {
      data = await fitbitActivityTimeseriesDataManager
          .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now(),
        userID: sp.getString('userId'),
        resource: fitbitActivityTimeseriesDataManager.type,
      )) as List<FitbitActivityTimeseriesData>;
    } on Exception catch (exception) {
      final sp = await SharedPreferences.getInstance();
      // Authorize the app
      String? userId = await FitbitConnector.authorize(
          context: context,
          clientID: AppCredentials.fitbitClientID,
          clientSecret: AppCredentials.fitbitClientSecret,
          redirectUri: AppCredentials.fitbitRedirectUri,
          callbackUrlScheme: AppCredentials.fitbitCallbackScheme);
      sp.setString('userId', userId!);

      data = await fitbitActivityTimeseriesDataManager
          .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now(),
        userID: sp.getString('userId'),
        resource: fitbitActivityTimeseriesDataManager.type,
      )) as List<FitbitActivityTimeseriesData>;
    }
    dynamic result;
    if (dataType == 'steps' || dataType == 'calories') {
      result = data[0].value!.toInt();
    } else {
      result = data[0].value!.toDouble();
    }
    return result;
  } // fetchData

  double getPercentage(String dataType, num n, SharedPreferences sp) {
    double goal;
    if (dataType == 'calories') {
      goal = 2000;
    } else if (dataType == 'steps') {
      goal = double.parse(sp.getString('goal')!);
    } else {
      // distance goal is computed considering an average step lenght of 1m
      goal = double.parse(sp.getString('goal')!) / 1000;
    }
    return n / goal;
  } // getPercentage

  Widget _dataStack(num data, String dataType, IconData dataIcon,
      Color dataColor, SharedPreferences sp) {
    return Stack(alignment: Alignment.center, children: [
      SizedBox(
        height: 150,
        width: 150,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          color: dataColor,
          value: getPercentage(dataType, data, sp),
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(dataIcon, size: 40),
        const SizedBox(height: 5),
        Text('$data', style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 5),
        if (dataType == 'steps' || dataType == 'calories')
          Text('${dataType[0].toUpperCase()}${dataType.substring(1)}',
              style: const TextStyle(fontSize: 20))
        else
          const Text('km', style: TextStyle(fontSize: 20))
      ])
    ]);
  } //_dataStack

  Widget _dataCircle(String dataType, IconData dataIcon, Color dataColor) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sp = snapshot.data as SharedPreferences;
            var data;
            if (dataType == 'steps') {
              data = sp.getInt('lastSteps');
            } else if (dataType == 'distance') {
              // round distance to second decimal
              num dist = sp.getDouble('lastDistance')!;
              data = num.parse(dist.toStringAsFixed(2));
            } else {
              data = sp.getInt('lastCalories');
            }

            if (data > 0) {
              return _dataStack(data, dataType, dataIcon, dataColor, sp);
            } else {
              return _dataStack(0, dataType, dataIcon, dataColor, sp);
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  } // _dataCircle

  Widget _currentBadge() {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sp = snapshot.data as SharedPreferences;
            int data = sp.getInt('lastSteps')!;
            final achievement = getAchievement(data, sp);
            return Container(
              color: const Color.fromARGB(255, 130, 207, 243),
              height: 100,
              width: 450,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                        text: "Right now, you are a ",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "${achievement.title}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: "!"),
                        ]),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(achievement.assetPicture!))
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

// Function to update missing activity DB entries. It returns an Activty only for
// the purpose of being used in a FutureBuilder
  Future<Activity?> _updateDB() async {
    final sp = await SharedPreferences.getInstance();
    int userId = sp.getInt('usercode')!;

    DateTime lastUpdate = DateTime.parse(sp.getString('lastUpdate')!);
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    // get yesterday at midnight
    yesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);

    Activity? latestActivity;

    // if last update was before yesterday, fill missing database entries up
    //until yesterday and update lastUpdate in shared preferences
    if (!isSameDay(yesterday, lastUpdate)) {
      var newSteps = await _fetchActivity('steps', lastUpdate, sp);
      var newDistance = await _fetchActivity('distance', lastUpdate, sp);
      var newCalories = await _fetchActivity('calories', lastUpdate, sp);
      var newVeryActiveMinutes =
          await _fetchActivity('minutesVeryActive', lastUpdate, sp);
      var newFairlyActiveMinutes =
          await _fetchActivity('minutesFairlyActive', lastUpdate, sp);

      int N = newSteps.length;

      for (var i = 0; i < N; i++) {
        DateTime dateTest = newSteps[i].dateOfMonitoring!.toUtc();

        Activity newActivity = Activity(
            null,
            userId,
            dateTest,
            newSteps[i].value!.toInt(),
            newCalories[i].value!.toInt(),
            newDistance[i].value!.toDouble(),
            (newFairlyActiveMinutes[i].value! +
                newVeryActiveMinutes[i].value!));
        await Provider.of<DatabaseRepository>(context, listen: false)
            .insertActivity(newActivity);

        latestActivity = newActivity;
        print('Added $dateTest entry');
      }

      // update last db update date
      // has to be done after everything to ensure that authorization goes through
      String newDate = DateFormat("yyyy-MM-dd").format(yesterday);
      sp.setString('lastUpdate', newDate);
      await Provider.of<DatabaseRepository>(context, listen: false)
          .updateDate(userId, newDate);
    }
    return latestActivity;
  } //_updateDB

  Future<List<FitbitActivityTimeseriesData>> _fetchActivity(
      String dataType, DateTime lastUpdate, SharedPreferences sp) async {
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
        FitbitActivityTimeseriesDataManager(
            clientID: AppCredentials.fitbitClientID,
            clientSecret: AppCredentials.fitbitClientSecret,
            type: dataType);

    final activityList = await fitbitActivityTimeseriesDataManager
        .fetch(FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
      userID: sp.getString('userId'),
      startDate: lastUpdate.add(const Duration(days: 1, hours: 2)),
      endDate: DateTime.now()
          .subtract(const Duration(days: 1)), //fetching until yesterday
      resource: fitbitActivityTimeseriesDataManager.type,
    )) as List<FitbitActivityTimeseriesData>;
    return activityList;
  } // _fetchActivty
}
