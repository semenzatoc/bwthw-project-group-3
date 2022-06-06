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
    /* //Minutes very active in the past month
    final durationVeryActive = await fetchMonthActivity('minutesVeryActive');
    //Minutes fairly active in the past month
    final durationFairlyActive =
        await fetchMonthActivity('minutesFairlyActive');*/
    //Classified as active if minimum of 30 minutes activity in more than 50% of
    //days in the past month

    final allDayMinutes = await fetchMonthActivity(context);
    double minDailyActive = 0;
    int countActiveDays = 0;

    for (var i = 0; i < 31; i++) {
      /*minDailyActive = minDailyActive +
          (durationVeryActive[i].value as double) +
          (durationFairlyActive[i].value as double);

      if (minDailyActive > 30) {
        countActiveDays = countActiveDays + 1;
      }*/
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

  /*Future<List<FitbitActivityTimeseriesData>> fetchMonthActivity(
      String dataType) async {
     FitbitActivityTimeseriesDataManager fitbitVeryActiveTimeseriesDataManager =
        FitbitActivityTimeseriesDataManager(
            clientID: AppCredentials.fitbitClientID,
            clientSecret: AppCredentials.fitbitClientSecret,
            type: dataType);

    final sp = await SharedPreferences.getInstance();

    final durationActivity = await fitbitVeryActiveTimeseriesDataManager
        .fetch(FitbitActivityTimeseriesAPIURL.monthWithResource(
      userID: sp.getString('userId'),
      baseDate:
          DateTime.now().subtract(Duration(days: 1)), //fetching until yesterday
      resource: fitbitVeryActiveTimeseriesDataManager.type,
    )) as List<FitbitActivityTimeseriesData>;
    return durationActivity;}*/
  Future<List<Activity>> fetchMonthActivity(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime.utc(now.year, now.month, now.day);
    List<DateTime> days = [];
    for (var i = 0; i <= 31; i++) {
      days.add(today.subtract(Duration(days: i, hours: 2)));
    }

    List<Activity> activeMinuteDays =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findActiivtyInPeriod(days);
    print('Hello');
    return activeMinuteDays;
  }
}
