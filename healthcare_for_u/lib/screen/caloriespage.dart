import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/utils/LineChartMonth.dart';
import 'package:healthcare_for_u/utils/LineChartWeek.dart';
import 'package:healthcare_for_u/utils/LineSeries.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/entities/activity.dart';
import '../utils/appcredentials.dart';
import '../utils/dataFetcher.dart';

class CaloriesPage extends StatefulWidget {
  CaloriesPage({Key? key}) : super(key: key);

  static const route = '/calories';
  static const routename = 'CaloriesPage';

  @override
  State<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  List<LineSeries> weekCalories = [];
  List<LineSeries> monthCalories = [];
  DataFetcher fetcher = DataFetcher();

  @override
  Widget build(BuildContext context) {
    print('${CaloriesPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(CaloriesPage.routename),
      ),
      body: Column(
        children: [
          //FutureBuilder to fetch weekly data of calories
          FutureBuilder(
              future: fetcher.fetchActivityFromDB('week', context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var weekActivity = snapshot.data as List<Activity>;
                  for (var i = 0; i < weekActivity.length; i++) {
                    int element = weekActivity[i].calories;
                    //create the weekCalories List<LineSeries> that is necessary for defining and displaying the LineChart
                    weekCalories.add(LineSeries(day: i, steps: element));
                  }
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text('Weekly Calories',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        LineChartWeek(data: weekCalories),
                      ]);
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          //FutureBuilder for fetch monthly data of calories
          FutureBuilder(
              future: fetcher.fetchActivityFromDB('month', context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var monthActivity = snapshot.data as List<Activity>;
                  for (var i = 0; i < monthActivity.length; i++) {
                    int element = monthActivity[i].calories;
                    //create the monthCalories List<LineSeries> that is necessary for defining and displaying the LineChart
                    monthCalories.add(LineSeries(day: i, steps: element));
                  }
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text('Monthly Calories',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        LineChartMonth(data: monthCalories),
                      ]);
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}

  
 //Page