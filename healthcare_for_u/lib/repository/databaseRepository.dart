import 'package:healthcare_for_u/database/database.dart';
import 'package:healthcare_for_u/database/entities/user.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //This method wraps the findAllUsers() method of the DAO
  Future<List<User>> findAllUsers() async {
    final results = await database.userDao.findAllUsers();
    return results;
  } //findAllUsers

  //This method wraps the findUser() method of the DAO
  Future<List<User>> findUser(String? username) async {
    final results = await database.userDao.findUser(username!);
    return results;
  } //findUser

  //This method wraps the findUser() method of the DAO
  Future<String> getUsername(String? username) async {
    final results = await database.userDao.getUsername(username!);
    return results as String;
  } //findUser

  //This method wraps the getPassword() method of the DAO
  Future<List<User>> getPassword(String? username) async {
    final results = await database.userDao.getPassword(username!);
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

} //DatabaseRepository
