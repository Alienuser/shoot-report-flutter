// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WeaponDao? _weaponDaoInstance;

  TrainingDao? _trainingDaoInstance;

  CompetitionDao? _competitionDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Weapon` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `order` INTEGER NOT NULL, `prefFile` TEXT NOT NULL, `show` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Training` (`id` INTEGER, `date` INTEGER NOT NULL, `image` TEXT NOT NULL, `indicator` INTEGER NOT NULL, `place` TEXT NOT NULL, `kind` TEXT NOT NULL, `shotCount` INTEGER NOT NULL, `shots` TEXT NOT NULL, `comment` TEXT NOT NULL, `weapon_id` INTEGER NOT NULL, FOREIGN KEY (`weapon_id`) REFERENCES `Weapon` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Competition` (`id` INTEGER, `date` INTEGER NOT NULL, `image` TEXT NOT NULL, `place` TEXT NOT NULL, `kind` TEXT NOT NULL, `shotCount` INTEGER NOT NULL, `shots` TEXT NOT NULL, `comment` TEXT NOT NULL, `weapon_id` INTEGER NOT NULL, FOREIGN KEY (`weapon_id`) REFERENCES `Weapon` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WeaponDao get weaponDao {
    return _weaponDaoInstance ??= _$WeaponDao(database, changeListener);
  }

  @override
  TrainingDao get trainingDao {
    return _trainingDaoInstance ??= _$TrainingDao(database, changeListener);
  }

  @override
  CompetitionDao get competitionDao {
    return _competitionDaoInstance ??=
        _$CompetitionDao(database, changeListener);
  }
}

class _$WeaponDao extends WeaponDao {
  _$WeaponDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _weaponInsertionAdapter = InsertionAdapter(
            database,
            'Weapon',
            (Weapon item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'order': item.order,
                  'prefFile': item.prefFile,
                  'show': item.show ? 1 : 0
                },
            changeListener),
        _weaponUpdateAdapter = UpdateAdapter(
            database,
            'Weapon',
            ['id'],
            (Weapon item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'order': item.order,
                  'prefFile': item.prefFile,
                  'show': item.show ? 1 : 0
                },
            changeListener),
        _weaponDeletionAdapter = DeletionAdapter(
            database,
            'Weapon',
            ['id'],
            (Weapon item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'order': item.order,
                  'prefFile': item.prefFile,
                  'show': item.show ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Weapon> _weaponInsertionAdapter;

  final UpdateAdapter<Weapon> _weaponUpdateAdapter;

  final DeletionAdapter<Weapon> _weaponDeletionAdapter;

  @override
  Stream<List<Weapon>> findAllWeapons() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM weapon WHERE show = true',
        mapper: (Map<String, Object?> row) => Weapon(
            row['id'] as int?,
            row['name'] as String,
            row['order'] as int,
            row['prefFile'] as String,
            (row['show'] as int) != 0),
        queryableName: 'Weapon',
        isView: false);
  }

  @override
  Future<void> showAllWeapons() async {
    await _queryAdapter.queryNoReturn('Update weapon SET show=true');
  }

  @override
  Future<void> insertWeapon(Weapon weapon) async {
    await _weaponInsertionAdapter.insert(weapon, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWeapon(Weapon weapon) async {
    await _weaponUpdateAdapter.update(weapon, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWeapon(Weapon weapon) async {
    await _weaponDeletionAdapter.delete(weapon);
  }
}

class _$TrainingDao extends TrainingDao {
  _$TrainingDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _trainingInsertionAdapter = InsertionAdapter(
            database,
            'Training',
            (Training item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'image': item.image,
                  'indicator': item.indicator,
                  'place': item.place,
                  'kind': item.kind,
                  'shotCount': item.shotCount,
                  'shots': _arrayConverter.encode(item.shots),
                  'comment': item.comment,
                  'weapon_id': item.weaponId
                },
            changeListener),
        _trainingUpdateAdapter = UpdateAdapter(
            database,
            'Training',
            ['id'],
            (Training item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'image': item.image,
                  'indicator': item.indicator,
                  'place': item.place,
                  'kind': item.kind,
                  'shotCount': item.shotCount,
                  'shots': _arrayConverter.encode(item.shots),
                  'comment': item.comment,
                  'weapon_id': item.weaponId
                },
            changeListener),
        _trainingDeletionAdapter = DeletionAdapter(
            database,
            'Training',
            ['id'],
            (Training item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'image': item.image,
                  'indicator': item.indicator,
                  'place': item.place,
                  'kind': item.kind,
                  'shotCount': item.shotCount,
                  'shots': _arrayConverter.encode(item.shots),
                  'comment': item.comment,
                  'weapon_id': item.weaponId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Training> _trainingInsertionAdapter;

  final UpdateAdapter<Training> _trainingUpdateAdapter;

  final DeletionAdapter<Training> _trainingDeletionAdapter;

  @override
  Stream<List<Training>> findAllTrainings() {
    return _queryAdapter.queryListStream('SELECT * FROM training',
        mapper: (Map<String, Object?> row) => Training(
            row['id'] as int?,
            _dateTimeConverter.decode(row['date'] as int),
            row['image'] as String,
            row['indicator'] as int,
            row['place'] as String,
            row['kind'] as String,
            row['shotCount'] as int,
            _arrayConverter.decode(row['shots'] as String),
            row['comment'] as String,
            row['weapon_id'] as int),
        queryableName: 'Training',
        isView: false);
  }

  @override
  Stream<List<Training>> findAllTrainingsForWeapon(int wid) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM training WHERE weapon_id = ?1 ORDER by date DESC',
        mapper: (Map<String, Object?> row) => Training(
            row['id'] as int?,
            _dateTimeConverter.decode(row['date'] as int),
            row['image'] as String,
            row['indicator'] as int,
            row['place'] as String,
            row['kind'] as String,
            row['shotCount'] as int,
            _arrayConverter.decode(row['shots'] as String),
            row['comment'] as String,
            row['weapon_id'] as int),
        arguments: [wid],
        queryableName: 'Training',
        isView: false);
  }

  @override
  Future<void> insertTraining(Training training) async {
    await _trainingInsertionAdapter.insert(training, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTraining(Training training) async {
    await _trainingUpdateAdapter.update(training, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTraining(Training training) async {
    await _trainingDeletionAdapter.delete(training);
  }
}

class _$CompetitionDao extends CompetitionDao {
  _$CompetitionDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _competitionInsertionAdapter = InsertionAdapter(
            database,
            'Competition',
            (Competition item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'image': item.image,
                  'place': item.place,
                  'kind': item.kind,
                  'shotCount': item.shotCount,
                  'shots': item.shots,
                  'comment': item.comment,
                  'weapon_id': item.weaponId
                },
            changeListener),
        _competitionDeletionAdapter = DeletionAdapter(
            database,
            'Competition',
            ['id'],
            (Competition item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'image': item.image,
                  'place': item.place,
                  'kind': item.kind,
                  'shotCount': item.shotCount,
                  'shots': item.shots,
                  'comment': item.comment,
                  'weapon_id': item.weaponId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Competition> _competitionInsertionAdapter;

  final DeletionAdapter<Competition> _competitionDeletionAdapter;

  @override
  Stream<List<Competition>> findAllCompetitions() {
    return _queryAdapter.queryListStream('SELECT * FROM competition',
        mapper: (Map<String, Object?> row) => Competition(
            row['id'] as int?,
            _dateTimeConverter.decode(row['date'] as int),
            row['image'] as String,
            row['place'] as String,
            row['kind'] as String,
            row['shotCount'] as int,
            row['shots'] as String,
            row['comment'] as String,
            row['weapon_id'] as int),
        queryableName: 'Competition',
        isView: false);
  }

  @override
  Stream<List<Competition>> findAllTrainingsForWeapon(int wid) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM competition WHERE weapon_id = ?1',
        mapper: (Map<String, Object?> row) => Competition(
            row['id'] as int?,
            _dateTimeConverter.decode(row['date'] as int),
            row['image'] as String,
            row['place'] as String,
            row['kind'] as String,
            row['shotCount'] as int,
            row['shots'] as String,
            row['comment'] as String,
            row['weapon_id'] as int),
        arguments: [wid],
        queryableName: 'Competition',
        isView: false);
  }

  @override
  Future<void> insertCompetition(Competition competition) async {
    await _competitionInsertionAdapter.insert(
        competition, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCompetition(Competition competition) async {
    await _competitionDeletionAdapter.delete(competition);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _arrayConverter = ArrayConverter();
