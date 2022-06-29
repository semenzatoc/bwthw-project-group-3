import 'package:healthcare_for_u/database/database.dart';
import 'package:healthcare_for_u/database/entities/activity.dart';
import 'package:healthcare_for_u/database/entities/user.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

////User methods
  //This method wraps the findAllUsers() method of the DAO
  Future<List<User>> findAllUsers() async {
    final results = await database.userDao.findAllUsers();
    return results;
  } //findAllUsers

  //This method wraps the findUser() method of the DAO
  Future<List<User?>> findUser(String? username) async {
    final results = await database.userDao.findUser(username!);
    return results;
  } //findUser

  Future<void> clearUserTable() async {
    await database.userDao.deleteAllUser();
    notifyListeners();
  }

  //This method searches the database and returns TRUE if username is already
  //there
  Future<bool> isRegistered(String? username) async {
    if (username == null) {
      return false;
    }
    final user = await database.userDao.findUser(username);
    final results = user.isNotEmpty;
    return results;
  } //isRegistered

  //This method wraps the insertUser() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertUser(User user) async {
    await database.userDao.insertUser(user);
    notifyListeners();
  } //insertUser

  //TDelete user from database
  Future<void> removeUser(int userId) async {
    var user = await database.userDao.findUserByID(userId) as User;
    await database.userDao.deleteUser(user);
    notifyListeners();
  } //removeUser

  Future<void> updatePicture(int usercode, String newImagepath) async {
    var user = await database.userDao.findUserByID(usercode) as User;
    user.profilepicture = newImagepath;
    await database.userDao.updateUser(user);
    notifyListeners();
  }

// function to update user weight in DB
  Future<void> updateWeight(int usercode, String newWeight) async {
    var user = await database.userDao.findUserByID(usercode) as User;
    user.weight = newWeight;
    await database.userDao.updateUser(user);
    notifyListeners();
  }

// function to update user height in DB
  Future<void> updateHeight(int usercode, String newHeight) async {
    var user = await database.userDao.findUserByID(usercode) as User;
    user.height = newHeight;
    await database.userDao.updateUser(user);
    notifyListeners();
  }

// function to update steps goal in database
  Future<void> updateGoal(int usercode, int newGoal) async {
    var user = await database.userDao.findUserByID(usercode) as User;
    user.goal = newGoal;
    await database.userDao.updateUser(user);
    notifyListeners();
  }

// function to update lastFetch date in user DB
  Future<void> updateDate(int usercode, String newDate) async {
    var user = await database.userDao.findUserByID(usercode) as User;
    user.lastUpdate = newDate;
    await database.userDao.updateUser(user);
    notifyListeners();
  }

//
//
//
//// Activity methods
  Future<List<Activity?>> findAllActivities() async {
    final results = await database.activityDao.findAllActivities();
    return results;
  }

  Future<List<Activity?>> findActivity(DateTime day) async {
    final results = await database.activityDao.getDayActivity(day);
    return results;
  } //findActivity

  Future<List<Activity>> findActivityInPeriod(List<DateTime> days) async {
    final results = await database.activityDao.findActivityInPeriod(days);
    return results;
  }

  Future<int> getDaySteps(DateTime day) async {
    final results = await database.activityDao.getDayActivity(day);
    return results[0].steps;
  } //getDaySteps

  Future<double> getDayDistance(DateTime day) async {
    final results = await database.activityDao.getDayActivity(day);
    return results.first.distance;
  } //getDayFloors

  Future<int> getDayCalories(DateTime day) async {
    final results = await database.activityDao.getDayActivity(day);
    return results.first.calories;
  } //getDayCalories

  Future<void> insertActivity(Activity activity) async {
    await database.activityDao.insertActivity(activity);
    notifyListeners();
  } //insertUser

  Future<bool> checkLastDate() async {
    final list = await database.activityDao
        .getDayActivity(DateTime.now().subtract(const Duration(days: 1)));
    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> clearActivityTable() async {
    await database.activityDao.deleteAllActivities();
    notifyListeners();
  }

  Future<void> deleteUserActivty(int userId) async {
    List<Activity> userActivities =
        await database.activityDao.getUserActivity(userId);

    for (var activity in userActivities) {
      await database.activityDao.deleteActivity(activity);
    }
  }
} //DatabaseRepository
