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

  @override
  Widget build(BuildContext context) {
    print('${StepPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(StepPage.routename),
      ),
      body: Column(
        children: [
          //FutureBuilder to fetch weekly data of steps
            FutureBuilder(
              future: _fetchActivityFromDB('week'),
              builder: (context,snapshot){
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
                      SizedBox(height: 10,),
                      Text('Weekly Steps', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                      LineChartWeek(data: weekSteps),]
                  );
                } else{
                  return const CircularProgressIndicator();
                }
              }),
              //FutureBuilder for fetch monthly data of steps
              FutureBuilder(
              future: _fetchActivityFromDB('month'),
              builder: (context,snapshot){
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
                      SizedBox(height: 10,),
                      Text('Monthly Steps', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                      LineChartMonth(data: monthSteps),]
                  );
                } else{
                  return const CircularProgressIndicator();
                }
              }),

        ],
      ),


      );

  } 
  
  Future<List<Activity>> _fetchActivityFromDB(String time) async {
    final sp = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    DateTime today = DateTime.utc(now.year, now.month, now.day);
    DataFetcher fetcher = DataFetcher();
    List<Activity> data = await fetcher.fetchRangeActivity(context, time);
    Activity todayActivity = Activity(
        null,
        sp.getInt('usercode')!,
        today,
        sp.getInt('lastSteps')!,
        sp.getInt('lastCalories')!,
        sp.getInt('lastFloors')!,
        0);
    data.add(todayActivity);
    return data;
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

  
 //Page