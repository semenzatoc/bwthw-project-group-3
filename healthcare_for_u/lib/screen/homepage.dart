import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../utils/appcredentials.dart';
import 'calendarpage.dart';
import 'healthpage.dart';

// Card per ogni attività. Le attività si aggiorneranno a seconda dei dati
// Ogni Card porta alla pagina di dettaglio dell'attività scelta.

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static const route = '/';
  static const routename = 'Home Page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              FutureBuilder(
                  future: _fetchSteps(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final steps = snapshot.data as double;
                      if (steps > 0) {
                        final percentage = stepsPercentage(steps);
                        return Stack(alignment: Alignment.center, children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Color.fromARGB(255, 242, 85, 28),
                              value: percentage,
                            ),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MdiIcons.footPrint, size: 40),
                                SizedBox(height: 5,),
                                Text('$steps',
                                  style: TextStyle(
                                      fontSize: 20),
                                ),SizedBox(height: 5,),
                                Text('Steps',
                                    style: TextStyle(
                                        fontSize: 20))
                              ])
                        ]);
                      } else {
                        return Stack(alignment: Alignment.center, children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Color.fromARGB(255, 242, 85, 28),
                              value: 0,
                            ),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MdiIcons.footPrint, size: 40.0), SizedBox(height: 5,),
                                Text('$steps',
                                  style: TextStyle(
                                      fontSize: 20),
                                ),SizedBox(height: 5,),
                                Text('Steps',
                                    style: TextStyle(
                                        fontSize: 20))
                              ])
                        ]);
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ]),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: _fetchCalories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final calories = snapshot.data as double;
                        if (calories > 0) {
                          final calPercentage = caloriesPercentage(calories);
                          return Stack(alignment: Alignment.center, children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                color: Color.fromARGB(255, 237, 80, 132),
                                value: calPercentage,
                              ),
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(MdiIcons.fire, size: 40,),SizedBox(height: 5,),
                                  Text('$calories',
                                    style: TextStyle(
                                        fontSize: 20),
                                  ),SizedBox(height: 5,),
                                  Text('Calories',
                                      style: TextStyle(
                                          fontSize: 20))
                                ])
                          ]);
                        } else {
                          return Stack(alignment: Alignment.center, children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                color: Color.fromARGB(255, 237, 80, 132),
                                value: 0,
                              ),
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(MdiIcons.fire, size: 40,),SizedBox(height: 5,),
                                  Text('$calories',
                                    style: TextStyle(
                                        fontSize: 20),
                                  ),SizedBox(height: 5,),
                                  Text('Calories',
                                      style: TextStyle(
                                          fontSize: 20))
                                ])
                          ]);
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
                    SizedBox(width: 20,),
                    FutureBuilder(
                    future: _fetchFloors(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final floors = snapshot.data as double;
                        if (floors > 0) {
                          final floorPercentage = floorsPercentage(floors);
                          return Stack(alignment: Alignment.center, children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                color: Color.fromARGB(255, 61, 239, 159),
                                value: floorPercentage,
                              ),
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(MdiIcons.stairs, size: 40,),SizedBox(height: 5,),
                                  Text('$floors',
                                    style: TextStyle(
                                        fontSize: 20),
                                  ),SizedBox(height: 5,),
                                  Text('Floors',
                                      style: TextStyle(
                                          fontSize: 20))
                                ])
                          ]);
                        } else {
                          return Stack(alignment: Alignment.center, children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                color: Color.fromARGB(255, 61, 239, 159),
                                value: 0,
                              ),
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(MdiIcons.stairs, size: 40,),SizedBox(height: 5,),
                                  Text('$floors',
                                    style: TextStyle(
                                        fontSize: 20),
                                  ),SizedBox(height: 5,),
                                  Text('Floors',
                                      style: TextStyle(
                                          fontSize: 20))
                                ])
                          ]);
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ],)
          ],
        ));
  }

  Future<double?> _fetchSteps() async {
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: AppCredentials.fitbitClientID,
      clientSecret: AppCredentials.fitbitClientSecret,
      type: 'steps',
    );

    final steps = await fitbitActivityTimeseriesDataManager
        .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
      date: DateTime.now(),
      userID: '7ML2XV',
      resource: fitbitActivityTimeseriesDataManager.type,
    )) as List<FitbitActivityTimeseriesData>;
    return steps[0].value as double;
  }

    Future<double?> _fetchCalories() async {
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: AppCredentials.fitbitClientID,
      clientSecret: AppCredentials.fitbitClientSecret,
      type: 'calories',
    );

    final calories = await fitbitActivityTimeseriesDataManager
        .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
      date: DateTime.now(),
      userID: '7ML2XV',
      resource: fitbitActivityTimeseriesDataManager.type,
    )) as List<FitbitActivityTimeseriesData>;
    return calories[0].value as double;
  }

      Future<double?> _fetchFloors() async {
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: AppCredentials.fitbitClientID,
      clientSecret: AppCredentials.fitbitClientSecret,
      type: 'floors',
    );

    final floors = await fitbitActivityTimeseriesDataManager
        .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
      date: DateTime.now(),
      userID: '7ML2XV',
      resource: fitbitActivityTimeseriesDataManager.type,
    )) as List<FitbitActivityTimeseriesData>;
    return floors[0].value as double;
  }

  // _fetchSteps //build
  double stepsPercentage(double steps) {
    return steps / 15000;
  }
    double caloriesPercentage(double calories) {
    return calories /2000;
  }
    double floorsPercentage(double calories) {
    return calories /10;
  }
}
