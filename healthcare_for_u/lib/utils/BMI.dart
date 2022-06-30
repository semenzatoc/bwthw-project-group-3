import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

double BMI(SharedPreferences sp) {
  var weightS = sp.getString('weight');
  var heightS = sp.getString('height');
  var weight = double.parse(weightS!);
  var height = double.parse(heightS!);
  double bmi = weight / pow(height / 100, 2);

  return bmi.truncateToDouble();
}
