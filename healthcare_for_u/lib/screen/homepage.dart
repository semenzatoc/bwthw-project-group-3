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

  static const route = '/home';
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _dataCircle(
                  'steps', MdiIcons.footPrint, Color.fromARGB(255, 242, 85, 28))
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
            )
          ],
        ));
  } // build

  Future<double?> _fetchData(String dataType) async {
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: AppCredentials.fitbitClientID,
      clientSecret: AppCredentials.fitbitClientSecret,
      type: dataType,
    );

    final data = await fitbitActivityTimeseriesDataManager
        .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
      date: DateTime.now(),
      userID: '7ML2XV',
      resource: fitbitActivityTimeseriesDataManager.type,
    )) as List<FitbitActivityTimeseriesData>;
    return data[0].value as double;
  } // fetchData

  double getPercentage(String dataType, double n) {
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
      double data, String dataType, IconData dataIcon, Color dataColor) {
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
        future: _fetchData(dataType),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as double;
            if (data > 0) {
              return _dataStack(data, dataType, dataIcon, dataColor);
            } else {
              return _dataStack(0, dataType, dataIcon, dataColor);
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  } // _dataCircle
}
