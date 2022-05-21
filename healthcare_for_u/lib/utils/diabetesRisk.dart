import 'package:healthcare_for_u/utils/calculateAge.dart';

int diabetesRisk(sp, gender, physicalActivity) {
  int risk = 0;
  //Age
  String string = sp.getString('dob');
  List<String> splitted = string.split('/');
  DateTime birthday = DateTime(
      int.parse(splitted[2]), int.parse(splitted[1]), int.parse(splitted[0]));
  int age = calculateAge(birthday);
  if (age >= 45 && age <= 54) {
    risk = risk + 2;
  } else if (age >= 55 && age <= 64) {
    risk = risk + 3;
  } else if (age > 64) {
    risk = risk + 4;
  }

  //BMI
  /* if (sp.getString('height2') != null) {
    //aggiorno i parametri di height da vedere in profile page
    sp.setString('height', sp.getString('height2'));
    //richiamo funzione per aggiornare bmi e lo aggiorno
    //sp.setString('bmi', sp.getString('bmi2'))
  }
  if (sp.getString('weight2') != null) {
    //aggiorno i parametri di weight da vedere in profile page
    sp.setString('weight', sp.getString('weight2'));
    //richiamo funzione per aggiornare bmi e lo aggiorno
    //sp.setString('bmi', sp.getString('bmi2'))
  }*/

  //
  //double bmi = double.parse(sp.getString('bmi'));
  //if (bmi >= 25 && bmi <= 30) {
  //risk = risk + 1;
  //} else if (bmi >30) {
  //risk = risk + 3;
  //}

  //Waist circumference
  String waist = sp.getString('waist');
  if (gender == 'F') {
    if (waist == '80-88 cm') {
      risk = risk + 3;
    } else if (waist == 'More than 88 cm') {
      risk = risk + 4;
    }
  } else {
    if (waist == '94-102 cm') {
      risk = risk + 3;
    } else if (waist == 'More than 102 cm') {
      risk = risk + 4;
    }
  }

  //Physical activity
  if (physicalActivity == false) {
    risk = risk + 2;
  }

  //Vegetables
  String veg = sp.getString('veg');
  if (veg == 'Not everyday') {
    risk = risk + 1;
  }
  //Medication
  String med = sp.getString('med');
  if (med == 'Yes') {
    risk = risk + 1;
  }
  //Glucose
  String glu = sp.getString('glu');
  if (glu == 'Yes') {
    risk = risk + 5;
  }
  //Diabetes
  String diab = sp.getString('diab');
  if (diab == 'Yes: grandparent, aunt, uncle or first cousin') {
    risk = risk + 3;
  } else if (diab == 'Yes: parent, brother, sister or own child') {
    risk = risk + 5;
  }
  return risk;
}
