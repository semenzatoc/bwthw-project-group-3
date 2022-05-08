import 'package:flutter/material.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'homepage.dart';
import 'calendarpage.dart';

// Card per ogni attività. Le attività si aggiorneranno a seconda dei dati
// Ogni Card porta alla pagina di dettaglio dell'attività scelta.

class HealthPage extends StatelessWidget {
  HealthPage({Key? key}) : super(key: key);

  static const route = '/health';
  static const routename = 'Health Status Page';

  @override
  Widget build(BuildContext context) {
    print('${HealthPage.routename} built');
    return Scaffold(
        appBar: AppBar(title: Text(HealthPage.routename), centerTitle: true),
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {}, child: Text('Check your health status!'))
              ]),
        ));
  } //build

} //HealthPage