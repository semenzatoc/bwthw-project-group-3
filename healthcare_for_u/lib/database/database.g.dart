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
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `username` TEXT NOT NULL, `password` TEXT NOT NULL, `isAuthorized` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Activity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user` TEXT NOT NULL, `date` INTEGER NOT NULL, `steps` INTEGER NOT NULL, `floors` INTEGER NOT NULL, `calories` INTEGER NOT NULL, `minutes` REAL NOT NULL)');

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
                  'isAuthorized': item.isAuthorized ? 1 : 0
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'isAuthorized': item.isAuthorized ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['username'] as String,
            row['password'] as String,
            (row['isAuthorized'] as int) != 0));
  }

  @override
  Future<void> updatePassword(String user, String pwd) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Users SET password = ?2 WHERE username = ?1',
        arguments: [user, pwd]);
  }

  @override
  Future<void> setAuthorization(String user, bool auth) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Users SET isAuthorized = ?2 WHERE username = ?1',
        arguments: [user, auth ? 1 : 0]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
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
                  'user': item.user,
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
                  'user': item.user,
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
                  'user': item.user,
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
            row['user'] as String,
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
            row['user'] as String,
            _dateTimeConverter.decode(row['date'] as int),
            row['steps'] as int,
            row['calories'] as int,
            row['floors'] as int,
            row['minutes'] as double),
        arguments: [_dateTimeConverter.encode(day)]);
  }

  @override
  Future<List<Activity>> getDaySteps(DateTime day) async {
    return _queryAdapter.queryList('SELECT steps FROM Activity WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int?,
            row['user'] as String,
            _dateTimeConverter.decode(row['date'] as int),
            row['steps'] as int,
            row['calories'] as int,
            row['floors'] as int,
            row['minutes'] as double),
        arguments: [_dateTimeConverter.encode(day)]);
  }

  @override
  Future<List<Activity>> getDayFloors(DateTime day) async {
    return _queryAdapter.queryList(
        'SELECT floors FROM Activity WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int?,
            row['user'] as String,
            _dateTimeConverter.decode(row['date'] as int),
            row['steps'] as int,
            row['calories'] as int,
            row['floors'] as int,
            row['minutes'] as double),
        arguments: [_dateTimeConverter.encode(day)]);
  }

  @override
  Future<List<Activity>> getDayCalories(DateTime day) async {
    return _queryAdapter.queryList(
        'SELECT calories FROM Activity WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int?,
            row['user'] as String,
            _dateTimeConverter.decode(row['date'] as int),
            row['steps'] as int,
            row['calories'] as int,
            row['floors'] as int,
            row['minutes'] as double),
        arguments: [_dateTimeConverter.encode(day)]);
  }

  @override
  Future<List<Activity>> getDayMinutes(DateTime day) async {
    return _queryAdapter.queryList(
        'SELECT minutes FROM Activity WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int?,
            row['user'] as String,
            _dateTimeConverter.decode(row['date'] as int),
            row['steps'] as int,
            row['calories'] as int,
            row['floors'] as int,
            row['minutes'] as double),
        arguments: [_dateTimeConverter.encode(day)]);
  }

  @override
  Future<void> setSteps(int steps, DateTime day) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Activity SET steps = ?1 WHERE date = ?2',
        arguments: [steps, _dateTimeConverter.encode(day)]);
  }

  @override
  Future<void> insertActivity(Activity activity) async {
    await _activityInsertionAdapter.insert(activity, OnConflictStrategy.abort);
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
