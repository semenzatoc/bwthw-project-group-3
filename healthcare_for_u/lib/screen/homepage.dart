import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/database/entities/activity.dart';
import 'package:healthcare_for_u/database/entities/user.dart';
import 'package:healthcare_for_u/repository/databaseRepository.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../utils/appcredentials.dart';
import 'calendarpage.dart';
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
    //_updateDB();
  } //initState

  void _getLastUpdate() async {
    final sp = await SharedPreferences.getInstance();
    if (sp.getInt('lastSteps') == null ||
        sp.getInt('lastFloors') == null ||
        sp.getInt('lastCalories') == null) {
      sp.setInt('lastSteps', 0);
      sp.setInt('lastFloors', 0);
      sp.setInt('lastCalories', 0);
      _updateData();
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
        onRefresh: () {
          setState(() {
            _updateData();
          });
          return Future<void>.delayed(const Duration(seconds: 2));
        },
        child: ListView(children: [
          const SizedBox(
            height: 50,
          ),
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
                _dataCircle('steps', MdiIcons.footPrint,
                    Color.fromARGB(255, 242, 85, 28))
              ]),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dataCircle('calories', MdiIcons.fire,
                      Color.fromARGB(255, 237, 80, 132)),
                  const SizedBox(width: 20),
                  _dataCircle('floors', MdiIcons.stairs,
                      Color.fromARGB(255, 61, 239, 159))
                ],
              ),
            ],
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _updateData();
          });
        },
        child: Icon(MdiIcons.reload),
        tooltip: 'Press to synch data',
      ),
    );
  } // build

  void _updateData() async {
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
    final difference = yesterday.difference(lastUpdate);

    Activity? latestActivity;
    // if last update was before yesterday, fill missing database entries up
    //until yesterday and update lastUpdate in shared preferences
    if (difference.inDays > 1) {
      sp.setString(
          'lastUpdate', DateFormat("yyyy-MM-dd HH:mm:ss").format(yesterday));

      var newSteps = await _fetchActivity('steps', lastUpdate, sp);
      var newFloors = await _fetchActivity('floors', lastUpdate, sp);
      var newCalories = await _fetchActivity('calories', lastUpdate, sp);
      var newVeryActiveMinutes =
          await _fetchActivity('minutesVeryActive', lastUpdate, sp);
      var newFairlyActiveMinutes =
          await _fetchActivity('minutesFairlyActive', lastUpdate, sp);

      int N = newSteps.length;
      for (var i = 0; i < N; i++) {
        // list goes from older to latest
        DateTime date = lastUpdate.add(Duration(days: i + 1));
        Activity newActivity = Activity(
            null,
            userId,
            date,
            newSteps[i].value!.toInt(),
            newCalories[i].value!.toInt(),
            newFloors[i].value!.toInt(),
            (newFairlyActiveMinutes[i].value! +
                newVeryActiveMinutes[i].value!));
        await Provider.of<DatabaseRepository>(context, listen: false)
            .insertActivity(newActivity);
        latestActivity = newActivity;
        print(date);
      }
    }
    return latestActivity;
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
