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

class DistancePage extends StatefulWidget {
  DistancePage({Key? key}) : super(key: key);

  static const route = '/distance';
  static const routename = 'DistancePage';

  @override
  State<DistancePage> createState() => _DistancePageState();
}

class _DistancePageState extends State<DistancePage> {
  List<LineSeries> weekDistance = [];
  List<LineSeries> monthDistance = [];
  DataFetcher fetcher = DataFetcher();

  @override
  Widget build(BuildContext context) {
    print('${DistancePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(DistancePage.routename),
      ),
      body: Column(
        children: [
          //FutureBuilder to fetch weekly data of distance
          FutureBuilder(
              future: fetcher.fetchActivityFromDB('week', context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var weekActivity = snapshot.data as List<Activity>;
                  for (var i = 0; i < weekActivity.length; i++) {
                    int element = weekActivity[i].distance.toInt();
                    //create the weekDistance List<LineSeries> that is necessary for defining and displaying the LineChart
                    weekDistance.add(LineSeries(day: i, steps: element));
                  }
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text('Weekly Distance',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        LineChartWeek(data: weekDistance),
                      ]);
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          //FutureBuilder for fetch monthly data of distance
          FutureBuilder(
              future: fetcher.fetchActivityFromDB('month', context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var monthActivity = snapshot.data as List<Activity>;
                  for (var i = 0; i < monthActivity.length; i++) {
                    int element = monthActivity[i].distance.toInt();
                    //create the monthDistance List<LineSeries> that is necessary for defining and displaying the LineChart
                    monthDistance.add(LineSeries(day: i, steps: element));
                  }
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text('Monthly Distance',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        LineChartMonth(data: monthDistance),
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