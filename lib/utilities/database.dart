import 'dart:async';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:floor/floor.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/array_converter.dart';
import 'package:shoot_report/utilities/date_time_converter.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';

@TypeConverters([DateTimeConverter, ArrayConverter])
@Database(version: 1, entities: [Weapon, Training, Competition])
abstract class FlutterDatabase extends FloorDatabase {
  WeaponDao get weaponDao;
  TrainingDao get trainingDao;
  CompetitionDao get competitionDao;
}
