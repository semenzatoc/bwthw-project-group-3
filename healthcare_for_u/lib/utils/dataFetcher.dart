import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/widgets.dart';
import 'package:healthcare_for_u/database/entities/activity.dart';
import 'package:healthcare_for_u/repository/databaseRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'appcredentials.dart';

class DataFetcher {
  // calculate month activity for DiabetesRisk function
  // returns TRUE if user has had at least an average of 30mins of physical
  // activity every day for the last month
  Future<bool> calcMonthActivity(BuildContext context) async {
    //Classified as active if minimum of 30 minutes activity in more than 50% of
    //days in the past month

    final allDayMinutes = await fetchRangeActivity(context, 'month');
    double minDailyActive = 0;
    int countActiveDays = 0;

    for (var i = 0; i < 31; i++) {
      minDailyActive = minDailyActive + allDayMinutes[i].minutes;
      if (minDailyActive > 30) {
        countActiveDays++;
      }
    } // for
    bool activity = false;
    if (countActiveDays / 30 > 0.5) {
      activity = true;
    }
    return activity;
    // fetchActivity
  }

  Future<List<Activity>> fetchRangeActivity(
      BuildContext context, String time) async {
    int N = 0;
    if (time == 'week') {
      N = 7;
    }
    if (time == 'month') {
      N = 31;
    }
    DateTime now = DateTime.now();
    DateTime today = DateTime.utc(now.year, now.month, now.day);
    List<DateTime> days = [];
    for (var i = 1; i <= N; i++) {
      //days.add(today.subtract(Duration(days: i))); //, hours: 2)));
      // if date doesn't work, remove hours:2
      days.add(today.subtract(Duration(days: i, hours: 2)));
    } //fetchRangeActivity

    List<Activity> activeMinuteDays =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findActivityInPeriod(days);

    return activeMinuteDays;
  }

// fetches the last week or month of activities from Database
  Future<List<Activity>> fetchActivityFromDB(
      String time, BuildContext context) async {
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
        sp.getDouble('lastDistance')!,
        0);
    data.add(todayActivity);
    return data;
  } //fetchActivtyFromDB
}
