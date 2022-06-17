import 'dart:collection';

import 'package:healthcare_for_u/database/entities/activity.dart';
import 'package:provider/provider.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/repository/databaseRepository.dart';
import 'package:healthcare_for_u/screen/profilepage.dart';
import 'package:healthcare_for_u/utils/getAchievement.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/appcredentials.dart';
import 'homepage.dart';
import 'healthpage.dart';
import 'package:healthcare_for_u/models/achievement.dart';

class CalendarPage extends StatefulWidget {
  static const route = '/calendar';
  static const routename = 'Calendar Page';

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${CalendarPage.routename}'),
      ),
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
      body: TableCalendar(
        firstDay: DateTime(2020, 1, 1),
        lastDay: DateTime(2025, 1, 1),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          bool isFuture = selectedDay.isAfter(DateTime.now());
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text('${DateFormat.yMMMd().format(selectedDay)}'
                        ' activities'),
                    alignment: Alignment.center,
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!isFuture)
                          FutureBuilder(
                              future: _fetchStepsFromDB(selectedDay),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final steps = snapshot.data as int;
                                  return FutureBuilder(
                                      future: SharedPreferences.getInstance(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var sp = snapshot.data
                                              as SharedPreferences;
                                          final achievement =
                                              getAchievement(steps, sp);
                                          String? goalS = sp.getString('goal');
                                          var goal = int.parse(goalS!);
                                          return Column(
                                            children: [
                                              _textSteps(steps, goal),
                                              const SizedBox(height: 10),
                                              Text(
                                                  'You were a ${achievement.title}!'),
                                              const SizedBox(height: 10),
                                              Image(
                                                  image: AssetImage(achievement
                                                      .assetPicture!))
                                            ],
                                          );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      });
                                } else {
                                  return CircularProgressIndicator();
                                }
                              }),
                        if (isFuture)
                          const Text(
                            'No data available for today',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        SizedBox(height: 20),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ));
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
    );
  } // build

  Future<int> _fetchStepsFromDB(DateTime day) async {
    if (isSameDay(day, DateTime.now())) {
      final sp = await SharedPreferences.getInstance();
      return sp.getInt('lastSteps')!;
    }

    List<Activity> allActivities =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findAllActivities() as List<Activity>;

    final daySteps = Provider.of<DatabaseRepository>(context, listen: false)
        .getDaySteps(day.subtract(const Duration(hours: 2)));
    // remove two hours to account for timezone
    return daySteps;
  }

  Widget _textSteps(int steps, int goal) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "You walked ",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: "$steps",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text: " steps out of your goal of ",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: "$goal!",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
} //_CalendarPageState
