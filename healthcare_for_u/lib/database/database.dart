// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:healthcare_for_u/database/typeConverters/dateTimeConverter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'daos/userDao.dart';
import 'daos/activityDao.dart';
import 'entities/user.dart';
import 'entities/activity.dart';
part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [User])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  //ActivityDao get activityDao;
}
