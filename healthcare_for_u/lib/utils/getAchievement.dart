import 'package:healthcare_for_u/models/achievement.dart';
import 'package:shared_preferences/shared_preferences.dart';

Achievement getAchievement(int steps, SharedPreferences sp) {
  String? goal_s = sp.getString('goal');
  var goal = int.parse(goal_s!);

  Achievement achievement = Achievement();

  if (steps < ((50 / 100) * goal)) {
    achievement.setTitle('Amoeba');
    achievement.setPicture('assets/trying.jpg');
  } else if (steps >= ((50 / 100) * goal) && steps < goal) {
    achievement.setTitle('Fighter');
    achievement.setPicture('assets/fighter.jpg');
  } else {
    achievement.setTitle('Champion');
    achievement.setPicture('assets/champion.jpg');
  }
  return achievement;
}
