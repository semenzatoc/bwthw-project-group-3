import 'package:fitbitter/fitbitter.dart';
import 'appcredentials.dart';

Future<bool> fetchMonthActivity() async {
  //Minutes very active in the past month
  FitbitActivityTimeseriesDataManager fitbitVeryActiveTimeseriesDataManager =
      FitbitActivityTimeseriesDataManager(
          clientID: AppCredentials.fitbitClientID,
          clientSecret: AppCredentials.fitbitClientSecret,
          type: 'minutesVeryActive');

  final durationVeryActive = await fitbitVeryActiveTimeseriesDataManager
      .fetch(FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    userID: '7ML2XV',
    startDate: DateTime.now().subtract(Duration(days: 30)),
    endDate: DateTime.now(),
    resource: fitbitVeryActiveTimeseriesDataManager.type,
  )) as List<FitbitActivityTimeseriesData>;

  //Minutes fairly active in the past month
  FitbitActivityTimeseriesDataManager fitbitFairlyActiveTimeseriesDataManager =
      FitbitActivityTimeseriesDataManager(
          clientID: AppCredentials.fitbitClientID,
          clientSecret: AppCredentials.fitbitClientSecret,
          type: 'minutesFairlyActive');

  final durationFairlyActive = await fitbitFairlyActiveTimeseriesDataManager
      .fetch(FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
    userID: '7ML2XV',
    startDate: DateTime.now().subtract(Duration(days: 30)),
    endDate: DateTime.now(),
    resource: fitbitFairlyActiveTimeseriesDataManager.type,
  )) as List<FitbitActivityTimeseriesData>;

  //Classified as active if minimum of 30 minutes activity in more than 50% of days in the past month
  double minDailyActive = 0;
  int countActiveDays = 0;
  for (var i = 0; i < durationVeryActive.length; i++) {
    minDailyActive = minDailyActive +
        (durationVeryActive[i].value as double) +
        (durationFairlyActive[i].value as double);
    if (minDailyActive > 30) {
      countActiveDays = countActiveDays + 1;
    }
  } // for
  bool activity = false;
  if (countActiveDays / durationVeryActive.length > 0.5) {
    activity = true;
  }
  return activity;
} // fetchActivity
