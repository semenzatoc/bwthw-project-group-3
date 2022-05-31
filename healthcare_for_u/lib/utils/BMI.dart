import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

double BMI(SharedPreferences sp) {
  var weight_s = sp.getString('weight');
  var height_s = sp.getString('height');
  var weight = double.parse(weight_s!);
  var height = double.parse(height_s!);
  double bmi = weight/pow(height/100,2);
  

  return bmi.truncateToDouble();
}