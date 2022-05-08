import 'package:flutter/material.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'calendarpage.dart';
import 'healthpage.dart';

// Card per ogni attività. Le attività si aggiorneranno a seconda dei dati
// Ogni Card porta alla pagina di dettaglio dell'attività scelta.

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  static const route = '/';
  static const routename = 'Home Page';

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
        body: (GridView.count(
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: 2,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ProfilePage.route);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      side: BorderSide(color: Colors.purpleAccent, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Colors.purple,
                          value: 0.7,
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Steps'), Icon(Icons.stairs)])
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ProfilePage.route);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      side: BorderSide(color: Colors.greenAccent, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Colors.green,
                          value: 0.7,
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Sleep'), Icon(Icons.access_alarms)])
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ProfilePage.route);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      side: BorderSide(color: Colors.blueAccent, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Colors.blue,
                          value: 0.7,
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('SpO2'),
                            Icon(
                              Icons.window_outlined,
                            )
                          ])
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ProfilePage.route);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      side: BorderSide(color: Colors.redAccent, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Colors.red,
                          value: 0.7,
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Heart'),
                            Icon(
                              Icons.favorite,
                            )
                          ])
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ProfilePage.route);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      side: BorderSide(color: Colors.yellowAccent, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Colors.yellow,
                          value: 0.7,
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Calories'),
                            Icon(Icons.apple_outlined)
                          ])
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ProfilePage.route);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      side: BorderSide(color: Colors.orangeAccent, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Colors.orange,
                          value: 0.7,
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Activity'), Icon(Icons.run_circle)])
                    ])),
              ),
            ])));
  } //build

} //HomePage