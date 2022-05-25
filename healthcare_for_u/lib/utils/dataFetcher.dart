import 'package:fitbitter/fitbitter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appcredentials.dart';

class DataFetcher {
  Future<bool> calcMonthActivity() async {
    //Minutes very active in the past month
    final durationVeryActive = await _fetchMonthActivity('minutesVeryActive');
    //Minutes fairly active in the past month
    final durationFairlyActive =
        await _fetchMonthActivity('minutesFairlyActive');
    //Classified as active if minimum of 30 minutes activity in more than 50% of
    //days in the past month
    double minDailyActive = 0;
    int countActiveDays = 0;

    for (var i = 0; i < 31; i++) {
      minDailyActive = minDailyActive +
          (durationVeryActive[i].value as double) +
          (durationFairlyActive[i].value as double);

      if (minDailyActive > 30) {
        countActiveDays = countActiveDays + 1;
      }
    } // for
    bool activity = false;
    if (countActiveDays / 30 > 0.5) {
      activity = true;
    }
    return activity;
    // fetchActivity
  }

  Future<List<FitbitActivityTimeseriesData>> _fetchMonthActivity(
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
    return durationActivity;
  }
}
