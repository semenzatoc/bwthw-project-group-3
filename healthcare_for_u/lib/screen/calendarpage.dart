import 'package:flutter/material.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'homepage.dart';
import 'healthpage.dart';

// Card per ogni attività. Le attività si aggiorneranno a seconda dei dati
// Ogni Card porta alla pagina di dettaglio dell'attività scelta.

class CalendarPage extends StatelessWidget {
  CalendarPage({Key? key}) : super(key: key);

  static const route = '/calendar';
  static const routename = 'Calendar Page';

  @override
  Widget build(BuildContext context) {
    print('${CalendarPage.routename} built');
    return Scaffold(
        appBar: AppBar(title: Text(CalendarPage.routename), centerTitle: true),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                tooltip: 'Calendar',
                icon: const Icon(Icons.calendar_month),
                onPressed: () {},
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
        body: Center(
          child: Text('Hello World'),
        ));
  } //build

} //CalendarPage