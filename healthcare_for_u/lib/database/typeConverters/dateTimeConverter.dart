import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue, isUtc: true);
  } //decode

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  } //encode
}//DateTimeConverter