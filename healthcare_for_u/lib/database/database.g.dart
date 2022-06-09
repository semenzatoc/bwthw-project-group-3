// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  ActivityDao? _activityDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `username` TEXT NOT NULL, `password` TEXT NOT NULL, `weight` TEXT NOT NULL, `height` TEXT NOT NULL, `dob` TEXT NOT NULL, `profilepicture` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Activity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER NOT NULL, `date` INTEGER NOT NULL, `steps` INTEGER NOT NULL, `floors` INTEGER NOT NULL, `calories` INTEGER NOT NULL, `minutes` REAL NOT NULL, FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  ActivityDao get activityDao {
    return _activityDaoInstance ??= _$ActivityDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'weight': item.weight,
                  'height': item.height,
                  'dob': item.dob,
                  'profilepicture': item.profilepicture
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'weight': item.weight,
                  'height': item.height,
                  'dob': item.dob,
                  'profilepicture': item.profilepicture
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'weight': item.weight,
                  'height': item.height,
                  'dob': item.dob,
                  'profilepicture': item.profilepicture
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['username'] as String,
            row['password'] as String,
            row['weight'] as String,
            row['height'] as String,
            row['dob'] as String,
            row['profilepicture'] as String));
  }

  @override
  Future<List<User?>> findUser(String username) async {
    return _queryAdapter.queryList('SELECT * FROM User WHERE username = ?1',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['username'] as String,
            row['password'] as String,
            row['weight'] as String,
            row['height'] as String,
            row['dob'] as String,
            row['profilepicture'] as String),
        arguments: [username]);
  }

  @override
  Future<void> deleteAllUser() async {
    await _queryAdapter.queryNoReturn('DELETE FROM User');
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$ActivityDao extends ActivityDao {
  _$ActivityDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _activityInsertionAdapter = InsertionAdapter(
            database,
            'Activity',
            (Activity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'date': _dateTimeConverter.encode(item.date),
                  'steps': item.steps,
                  'floors': item.floors,
                  'calories': item.calories,
                  'minutes': item.minutes
                }),
        _activityUpdateAdapter = UpdateAdapter(
            database,
            'Activity',
            ['id'],
            (Activity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'date': _dateTimeConverter.encode(item.date),
                  'steps': item.steps,
                  'floors': item.floors,
                  'calories': item.calories,
                  'minutes': item.minutes
                }),
        _activityDeletionAdapter = DeletionAdapter(
            database,
            'Activity',
            ['id'],
            (Activity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'date': _dateTimeConverter.encode(item.date),
                  'steps': item.steps,
                  'floors': item.floors,
                  'calories': item.calories,
                  'minutes': item.minutes
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Activity> _activityInsertionAdapter;

  final UpdateAdapter<Activity> _activityUpdateAdapter;

  final DeletionAdapter<Activity> _activityDeletionAdapter;

  @override
  Future<List<Activity>> findAllActivities() async {
    return _queryAdapter.queryList('SELECT * FROM Activity',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int?,
            row['userId'] as int,
            _dateTimeConverter.decode(row['date'] as int),
            row['steps'] as int,
            row['calories'] as int,
            row['floors'] as int,
            row['minutes'] as double));
  }

  @override
  Future<List<Activity>> getDayActivity(DateTime day) async {
    return _queryAdapter.queryList('SELECT * FROM Activity WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int?,
            row['userId'] as int,
            _dateTimeConverter.decode(row['date'] as int),
            row['steps'] as int,
            row['calories'] as int,
            row['floors'] as int,
            row['minutes'] as double),
        arguments: [_dateTimeConverter.encode(day)]);
  }

  @override
  Future<List<Activity>> findActivityInPeriod(List<DateTime> days) async {
    const offset = 1;
    final _sqliteVariablesForDays =
        Iterable<String>.generate(days.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM Activity WHERE date IN (' +
            _sqliteVariablesForDays +
            ')',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int?,
            row['userId'] as int,
            _dateTimeConverter.decode(row['date'] as int),
            row['steps'] as int,
            row['calories'] as int,
            row['floors'] as int,
            row['minutes'] as double),
        arguments: [
          ...days.map((element) => _dateTimeConverter.encode(element))
        ]);
  }

  @override
  Future<void> deleteAllActivities() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Activity');
  }

  @override
  Future<void> insertActivity(Activity activity) async {
    await _activityInsertionAdapter.insert(
        activity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateActivity(Activity activity) async {
    await _activityUpdateAdapter.update(activity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteActivity(Activity activity) async {
    await _activityDeletionAdapter.delete(activity);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
