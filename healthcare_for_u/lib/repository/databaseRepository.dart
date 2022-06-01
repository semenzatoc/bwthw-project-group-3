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

  //This method wraps the deleteUser() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> removeUser(User user) async {
    await database.userDao.deleteUser(user);
    notifyListeners();
  } //removeUser

//// Activity methods
  Future<List<Activity?>> findAllActivities() async {
    final results = await database.activityDao.findAllActivities();
    return results;
  } //findAllUsers

  //This method wraps the findUser() method of the DAO
  Future<List<Activity?>> findActivity(DateTime day) async {
    final results = await database.activityDao.getDayActivity(day);
    return results;
  } //findUser

  Future<int> getDaySteps(DateTime day) async {
    final results = await database.activityDao.getDayActivity(day);
    return results.first.steps;
  } //getDaySteps

  Future<int> getDayFloors(DateTime day) async {
    final results = await database.activityDao.getDayActivity(day);
    return results.first.floors;
  } //getDayFloors

  Future<int> getDayCalories(DateTime day) async {
    final results = await database.activityDao.getDayActivity(day);
    return results.first.calories;
  } //getDayCalories
} //DatabaseRepository
