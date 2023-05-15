import 'dart:developer';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/database.dart';

class AppMigration {
  ///
  /// Migration functions
  ///

  static void migrate_1_6_0(FlutterDatabase database) {
    // Migrate the database
    addEmptyShots(database);
    replaceNullValues(database);
    migrateDates(database);
    addWeapon(database);
  }

  ///
  /// Helper functions
  ///

  static void addEmptyShots(FlutterDatabase database) {
    log("Adding shots start.", name: "Migration");
    database.trainingDao.findAllTrainings().forEach((elements) {
      for (var element in elements) {
        if (element.shots.length < (element.shotCount / 10)) {
          for (int i = 0;
              i <= (element.shotCount / 10) - element.shots.length;
              i++) {
            element.shots.add(-1);
          }
          database.trainingDao.updateTraining(element);
        }
      }

      database.competitionDao.findAllCompetitions().forEach((elements) {
        for (var element in elements) {
          if (element.shots.length < (element.shotCount / 10)) {
            for (int i = 0;
                i <= (element.shotCount / 10) - element.shots.length;
                i++) {
              element.shots.add(-1);
            }
            database.competitionDao.updateCompetition(element);
          }
        }
      });
    });
    log("Adding shots finished.", name: "Migration");
  }

  static void replaceNullValues(FlutterDatabase database) {
    log("Replacing null values start.", name: "Migration");

    database.trainingDao.findAllTrainings().forEach((elements) {
      for (var element in elements) {
        if (element.shots.contains(null)) {
          element.shots[element.shots.indexOf(null)] = -1;
          database.trainingDao.updateTraining(element);
        }
      }
    });

    database.competitionDao.findAllCompetitions().forEach((elements) {
      for (var element in elements) {
        if (element.shots.contains(null)) {
          element.shots[element.shots.indexOf(null)] = -1;
          database.competitionDao.updateCompetition(element);
        }
      }
    });

    log("Replacing null values finished.", name: "Migration");
  }

  static void migrateDates(FlutterDatabase database) {
    log("Migrating dates start.", name: "Migration");

    database.trainingDao.findAllTrainings().forEach((elements) {
      for (var element in elements) {
        if (element.date.millisecondsSinceEpoch.toString().length > 13) {
          var calculation = element.date.millisecondsSinceEpoch
              .toString()
              .substring(
                  0, element.date.millisecondsSinceEpoch.toString().length - 1);
          element.date =
              DateTime.fromMillisecondsSinceEpoch(int.parse(calculation));
          database.trainingDao.updateTraining(element);
        } else if (element.date.millisecondsSinceEpoch.toString().length ==
            12) {
          var calculation =
              "${element.date.millisecondsSinceEpoch.toString()}0";
          element.date =
              DateTime.fromMillisecondsSinceEpoch(int.parse(calculation));
          database.trainingDao.updateTraining(element);
        } else if (element.date.millisecondsSinceEpoch.toString().length ==
            11) {
          var calculation =
              "${element.date.millisecondsSinceEpoch.toString()}00";
          element.date =
              DateTime.fromMillisecondsSinceEpoch(int.parse(calculation));
          database.trainingDao.updateTraining(element);
        }
      }
    });

    database.competitionDao.findAllCompetitions().forEach((elements) {
      for (var element in elements) {
        if (element.date.millisecondsSinceEpoch.toString().length > 13) {
          var calculation = element.date.millisecondsSinceEpoch
              .toString()
              .substring(
                  0, element.date.millisecondsSinceEpoch.toString().length - 1);
          element.date =
              DateTime.fromMillisecondsSinceEpoch(int.parse(calculation));
          database.competitionDao.updateCompetition(element);
        } else if (element.date.millisecondsSinceEpoch.toString().length ==
            12) {
          var calculation =
              "${element.date.millisecondsSinceEpoch.toString()}0";
          element.date =
              DateTime.fromMillisecondsSinceEpoch(int.parse(calculation));
          database.competitionDao.updateCompetition(element);
        } else if (element.date.millisecondsSinceEpoch.toString().length ==
            11) {
          var calculation =
              "${element.date.millisecondsSinceEpoch.toString()}00";
          element.date =
              DateTime.fromMillisecondsSinceEpoch(int.parse(calculation));
          database.competitionDao.updateCompetition(element);
        }
      }
    });

    log("Migrating dates finished.", name: "Migration");
  }

  static void addWeapon(FlutterDatabase database) async {
    log("Adding weapon start.", name: "Migration");

    await database.weaponDao
        .insertWeapon(Weapon(13, "weapon_12", 12, "prefWeapon12", true));

    log("Adding weapon finished.", name: "Migration");
  }

  ///
  /// General functions
  ///
  static void loadDefaultWeapons(WeaponDao weaponDao) async {
    log("Loading initial weapons.", name: "Migration");

    await weaponDao
        .insertWeapon(Weapon(1, "weapon_00", 0, "prefWeapon00", true));
    await weaponDao
        .insertWeapon(Weapon(2, "weapon_01", 1, "prefWeapon01", true));
    await weaponDao
        .insertWeapon(Weapon(3, "weapon_02", 2, "prefWeapon02", true));
    await weaponDao
        .insertWeapon(Weapon(4, "weapon_03", 3, "prefWeapon03", true));
    await weaponDao
        .insertWeapon(Weapon(5, "weapon_04", 4, "prefWeapon04", true));
    await weaponDao
        .insertWeapon(Weapon(6, "weapon_05", 5, "prefWeapon05", true));
    await weaponDao
        .insertWeapon(Weapon(7, "weapon_06", 6, "prefWeapon06", true));
    await weaponDao
        .insertWeapon(Weapon(8, "weapon_07", 7, "prefWeapon07", true));
    await weaponDao
        .insertWeapon(Weapon(9, "weapon_08", 8, "prefWeapon08", true));
    await weaponDao
        .insertWeapon(Weapon(10, "weapon_09", 9, "prefWeapon09", true));
    await weaponDao
        .insertWeapon(Weapon(11, "weapon_10", 10, "prefWeapon10", true));
    await weaponDao
        .insertWeapon(Weapon(12, "weapon_11", 11, "prefWeapon11", true));
    await weaponDao
        .insertWeapon(Weapon(13, "weapon_12", 12, "prefWeapon12", true));

    log("Loading initial weapons finished.", name: "Migration");
  }
}
