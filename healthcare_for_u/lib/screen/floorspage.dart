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

class FloorsPage extends StatefulWidget {
  FloorsPage({Key? key}) : super(key: key);

  static const route = '/floors';
  static const routename = 'FloorsPage';

  @override
  State<FloorsPage> createState() => _FloorsPageState();
}

class _FloorsPageState extends State<FloorsPage> {
   List<LineSeries> weekFloors = [];
   List<LineSeries> monthFloors = [];

  @override
  Widget build(BuildContext context) {
    print('${FloorsPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(FloorsPage.routename),
      ),
      body: Column(
        children: [
          //FutureBuilder to fetch weekly data of floors
            FutureBuilder(
              future: _fetchActivityFromDB('week'),
              builder: (context,snapshot){
                if (snapshot.hasData) {
                  var weekActivity = snapshot.data as List<Activity>;
                  for (var i = 0; i < weekActivity.length; i++) {
                    int element = weekActivity[i].floors;
                    //create the weekFloors List<LineSeries> that is necessary for defining and displaying the LineChart
                    weekFloors.add(LineSeries(day: i, steps: element)); 
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text('Weekly Floors', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                      LineChartWeek(data: weekFloors),]
                  );
                } else{
                  return const CircularProgressIndicator();
                }
              }),
              //FutureBuilder for fetch monthly data of floors
              FutureBuilder(
              future: _fetchActivityFromDB('month'),
              builder: (context,snapshot){
                if (snapshot.hasData) {
                  var monthActivity = snapshot.data as List<Activity>;
                  for (var i = 0; i < monthActivity.length; i++) {
                    int element = monthActivity[i].floors;
                    //create the monthFloors List<LineSeries> that is necessary for defining and displaying the LineChart
                    monthFloors.add(LineSeries(day: i, steps: element)); 
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text('Monthly Floors', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                      LineChartMonth(data: monthFloors),]
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