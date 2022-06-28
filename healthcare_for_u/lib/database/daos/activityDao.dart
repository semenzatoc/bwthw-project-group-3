import 'package:healthcare_for_u/database/entities/activity.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class ActivityDao {
  //Query #1: SELECT -> this allows to obtain all the entries of the Actiivty table
  @Query('SELECT * FROM Activity')
  Future<List<Activity>> findAllActivities();

  //Query #2: SELECT -> this allows to obtain all the entries of selected day
  @Query('SELECT * FROM Activity WHERE date = :day')
  Future<List<Activity>> getDayActivity(DateTime day);

  @Query('SELECT * FROM Activity WHERE date IN (:days)')
  Future<List<Activity>> findActivityInPeriod(List<DateTime> days);

  @Query('SELECT * FROM Activity WHERE userId = :userId')
  Future<List<Activity>> getUserActivity(int userId);

  @Query('DELETE FROM Activity')
  Future<void> deleteAllActivities();

  /*//Query #2: SELECT -> this allows to obtain the steps of selected day
  @Query('SELECT steps FROM Activity WHERE date = :day')
  Future<List<Activity>> getDaySteps(DateTime day);

  //Query #2: SELECT -> this allows to obtain the floors of selected day
  @Query('SELECT floors FROM Activity WHERE date = :day')
  Future<List<Activity>> getDayFloors(DateTime day);

  //Query #2: SELECT -> this allows to obtain the calories of selected day
  @Query('SELECT calories FROM Activity WHERE date = :day')
  Future<List<Activity>> getDayCalories(DateTime day);

  //Query #2: SELECT -> this allows to obtain the minutes of selected day
  @Query('SELECT minutes FROM Activity WHERE date = :day')
  Future<List<Activity>> getDayMinutes(DateTime day);*/

  //Query #2: INSERT -> this allows to add a Activity in the table
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertActivity(Activity activity);

  //Query #3: DELETE -> this allows to delete a Activity from the table
  @delete
  Future<void> deleteActivity(Activity activity);

//Query #4: UPDATE -> this allows to update Activity details
  @Update()
  Future<void> updateActivity(Activity activity);

  /* //Query #4: UPDATE -> this allows to update Activity details
  @Query('UPDATE Activity SET steps = :steps WHERE date = :day')
  Future<void> setSteps(int steps, DateTime day);*/
}//ActivityDao