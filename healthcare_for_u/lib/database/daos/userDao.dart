import 'package:healthcare_for_u/database/entities/user.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class UserDao {
  //Query #1: SELECT -> this allows to obtain all the entries of the Meal table
  @Query('SELECT * FROM User')
  Future<List<User>> findAllUsers();

  //Query #2: INSERT -> this allows to add a User in the table
  @Insert(onConflict: OnConflictStrategy.abort)
  Future<void> insertUser(User user);

  //Query #3: DELETE -> this allows to delete a User from the table
  @delete
  Future<void> deleteUser(User user);

  //Query #4: UPDATE -> this allows to update User details
  @Query('UPDATE Users SET password = :pwd WHERE username = :user')
  Future<void> updatePassword(String user, String pwd);

  //Query #5: UPDATE -> this allows to update User details
  @Query('UPDATE Users SET isAuthorized = :auth WHERE username = :user')
  Future<void> setAuthorization(String user, bool auth);
}//MealDao