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
import 'package:healthcare_for_u/utils/dataFetcher.dart';

import '../utils/appcredentials.dart';
import 'calendarpage.dart';
import 'caloriespage.dart';
import 'floorspage.dart';
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
        sp.getInt('lastFloors') == null ||
        sp.getInt('lastCalories') == null) {
      sp.setInt('lastSteps', 0);
      sp.setInt('lastFloors', 0);
      sp.setInt('lastCalories', 0);
    }

    // if lastFetch isn't today, do the first fetch of the day.
    // We can use the shared preference "lastUpdate" and check that it's yesterday.
    //If not, today there hasn't been any access yet and we need to fetch.
    DateTime lastFetch = DateTime.parse(sp.getString('lastUpdate')!)
        .add(const Duration(days: 1));
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    if (!isSameDay(today, lastFetch)) {
      await _updateData();
      print('First data fetch of the day completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(title: Text(HomePage.routename), centerTitle: true),
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
          await _updateData();
          print('Data fetched');
        },
        child: ListView(children: [
          currentLevel(),
          const SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                      Color.fromARGB(255, 242, 85, 28)),
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
                          Color.fromARGB(255, 237, 80, 132)),
                      onTap: () {
                        Navigator.pushNamed(context, CaloriesPage.route);
                      }),
                  const SizedBox(width: 20),
                  InkWell(
                    child: _dataCircle('floors', MdiIcons.stairs,
                        Color.fromARGB(255, 61, 239, 159)),
                    onTap: () {
                      Navigator.pushNamed(context, FloorsPage.route);
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

  _updateData() async {
    final sp = await SharedPreferences.getInstance();
    int steps = await _fetchData('steps');
    int floors = await _fetchData('floors');
    int calories = await _fetchData('calories');
    sp.setInt('lastSteps', steps);
    sp.setInt('lastFloors', floors);
    sp.setInt('lastCalories', calories);
  }

  Future<int> _fetchData(String dataType) async {
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: AppCredentials.fitbitClientID,
      clientSecret: AppCredentials.fitbitClientSecret,
      type: dataType,
    );

    final sp = await SharedPreferences.getInstance();

    final data = await fitbitActivityTimeseriesDataManager
        .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
      date: DateTime.now(),
      userID: sp.getString('userId'),
      resource: fitbitActivityTimeseriesDataManager.type,
    )) as List<FitbitActivityTimeseriesData>;
    return data[0].value!.toInt();
  } // fetchData

  double getPercentage(String dataType, int n) {
    double goal;
    if (dataType == 'calories') {
      goal = 2000;
    } else if (dataType == 'steps') {
      goal = 15000;
    } else {
      goal = 10;
    }
    return n / goal;
  } // getPercentage

  Widget _dataStack(
      int data, String dataType, IconData dataIcon, Color dataColor) {
    return Stack(alignment: Alignment.center, children: [
      SizedBox(
        height: 150,
        width: 150,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          color: dataColor,
          value: getPercentage(dataType, data),
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(dataIcon, size: 40),
        const SizedBox(height: 5),
        Text('$data', style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 5),
        Text('${dataType[0].toUpperCase()}${dataType.substring(1)}',
            style: const TextStyle(fontSize: 20))
      ])
    ]);
  } //_dataStack

  Widget _dataCircle(String dataType, IconData dataIcon, Color dataColor) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sp = snapshot.data as SharedPreferences;
            int data;
            if (dataType == 'steps') {
              data = sp.getInt('lastSteps') as int;
            } else if (dataType == 'floors') {
              data = sp.getInt('lastFloors') as int;
            } else {
              data = sp.getInt('lastCalories') as int;
            }

            if (data > 0) {
              return _dataStack(data, dataType, dataIcon, dataColor);
            } else {
              return _dataStack(0, dataType, dataIcon, dataColor);
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  } // _dataCircle

  Widget currentLevel() {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sp = snapshot.data as SharedPreferences;
            int data = sp.getInt('lastSteps')!;
            final achievement = getAchievement(data, sp);
            return Container(
              color: Color.fromARGB(255, 130, 207, 243),
              height: 100,
              width: 450,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Right now you are a ${achievement.title}!',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(width: 20),
                  CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(achievement.assetPicture!))
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

// if isSameDay(DateTime.parse(sp.getString('lastAccess),DateTime.now())){
// // do nothing}{
// else
// // set lastSteps etc to 0};

  Future<Activity?> _updateDB() async {
    final sp = await SharedPreferences.getInstance();
    String username = sp.getString('username')!;
    List<User> users =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findAllUsers();
    int userId = users.firstWhere((user) => user.username == username).id!;

    DateTime lastUpdate = DateTime.parse(sp.getString('lastUpdate')!);
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    // get yesterday at midnight
    yesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);

    Activity? latestActivity;
    // if last update was before yesterday, fill missing database entries up
    //until yesterday and update lastUpdate in shared preferences
    //if (difference.inDays > 1) {
    if (!isSameDay(yesterday, lastUpdate)) {
      var newSteps = await _fetchActivity('steps', lastUpdate, sp);
      var newFloors = await _fetchActivity('floors', lastUpdate, sp);
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
            newFloors[i].value!.toInt(),
            (newFairlyActiveMinutes[i].value! +
                newVeryActiveMinutes[i].value!));
        await Provider.of<DatabaseRepository>(context, listen: false)
            .insertActivity(newActivity);

        latestActivity = newActivity;

        List<Activity> dayActivity =
            await Provider.of<DatabaseRepository>(context, listen: false)
                .findActivity(dateTest) as List<Activity>;

        print('Added $dateTest entry');
      }

      // update last db update date
      // has to be done after everything to ensure that authorization goes through
      sp.setString(
          'lastUpdate', DateFormat("yyyy-MM-dd HH:mm:ss").format(yesterday));
    }
    return latestActivity;
  }

// fetches the last week or month of activities
  Future<List<Activity>> fetchActivityFromDB(String time) async {
    final sp = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    DateTime today = DateTime.utc(now.year, now.month, now.day);
    DataFetcher fetcher = DataFetcher();
    List<Activity> data = await fetcher.fetchRangeActivity(context, time);
    Activity todayActivity = Activity(
        null,
        sp.getInt('usercode')!,
        today,
        sp.getInt('lastSteps')!,
        sp.getInt('lastCalories')!,
        sp.getInt('lastFloors')!,
        0);
    data.add(todayActivity);
    return data;
  }

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
      startDate: lastUpdate.add(const Duration(days: 1)),
      endDate: DateTime.now()
          .subtract(const Duration(days: 1)), //fetching until yesterday
      resource: fitbitActivityTimeseriesDataManager.type,
    )) as List<FitbitActivityTimeseriesData>;
    return activityList;
  }
}
