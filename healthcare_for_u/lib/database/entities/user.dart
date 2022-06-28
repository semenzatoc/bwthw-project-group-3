import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class User {
  //id will be the primary key of the table. Moreover, it will be autogenerated.
  //id is nullable since it is autogenerated.
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String username;

  String password;

  String name;
  String gender;
  String weight;
  String height;
  String dob;
  String profilepicture;
  int goal;
  String lastUpdate;

  //Default constructor
  User(
      this.id,
      this.username,
      this.password,
      this.name,
      this.gender,
      this.weight,
      this.height,
      this.dob,
      this.goal,
      this.profilepicture,
      this.lastUpdate); //, this.lastfetch);
}//Todo