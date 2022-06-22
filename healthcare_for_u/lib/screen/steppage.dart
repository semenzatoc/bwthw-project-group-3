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

class StepPage extends StatefulWidget {
  StepPage({Key? key}) : super(key: key);

  static const route = '/step';
  static const routename = 'StepPage';

  @override
  State<StepPage> createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
  List<LineSeries> weekSteps = [];
  List<LineSeries> monthSteps = [];
  DataFetcher fetcher = DataFetcher();

  @override
  Widget build(BuildContext context) {
    print('${StepPage.routename} built');
    return Scaffold(
        appBar: AppBar(
          title: Text(StepPage.routename),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //FutureBuilder to fetch weekly data of steps
              FutureBuilder(
                  future: fetcher.fetchActivityFromDB('week', context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var weekActivity = snapshot.data as List<Activity>;
                      for (var i = 0; i < weekActivity.length; i++) {
                        int element = weekActivity[i].steps;
                        //create the weekSteps List<LineSeries> that is necessary for defining and displaying the LineChart
                        weekSteps.add(LineSeries(day: i, steps: element));
                      }
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text('Weekly Steps',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            LineChartWeek(data: weekSteps),
                          ]);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              //FutureBuilder for fetch monthly data of steps
              FutureBuilder(
                  future: fetcher.fetchActivityFromDB('month', context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var monthActivity = snapshot.data as List<Activity>;
                      for (var i = 0; i < monthActivity.length; i++) {
                        int element = monthActivity[i].steps;
                        //create the monthSteps List<LineSeries> that is necessary for defining and displaying the LineChart
                        monthSteps.add(LineSeries(day: i, steps: element));
                      }
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text('Monthly Steps',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            LineChartMonth(data: monthSteps),
                          ]);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ));
  }
}//Page