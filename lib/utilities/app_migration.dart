import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/models/type.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/type_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/database.dart';

class AppMigration {
  ///
  /// Migration functions
  ///
  static Future<int> migrate_1_7_0(FlutterDatabase database) async {
    // Migrate the database
    await migrateUser();
    await migrateDevice();
    await migrateTypes(database);
    await migrateWeapons(database);

    //await firebaseDevice(database);
    return 0;
  }

  ///
  /// Helper functions
  ///
  static Future<int> migrateUser() async {
    DatabaseReference firebaseDatabase = FirebaseDatabase.instance
        .ref("${FirebaseAuth.instance.currentUser?.uid}/user");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await firebaseDatabase.set({
      "name": prefs.getString("data_person_name"),
      "age": prefs.getString("data_person_age"),
      "height": prefs.getString("data_person_height"),
      "club_1": prefs.getString("data_person_club_1"),
      "club_2": prefs.getString("data_person_club_2"),
      "trainer": prefs.getString("data_person_trainer"),
      "trainer_mail": prefs.getString("data_person_trainer_mail"),
      "squadtrainer": prefs.getString("data_person_squadtrainer"),
      "squadtrainer_mail": prefs.getString("data_person_squadtrainer_mail"),
    });
    return 0;
  }

  static Future<int> migrateDevice() async {
    DatabaseReference firebaseDatabase = FirebaseDatabase.instance
        .ref("${FirebaseAuth.instance.currentUser?.uid}/device");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await firebaseDatabase.set({"data": prefs.getString("data_device")});
    return 0;
  }

  static Future<int> migrateTypes(FlutterDatabase localDatabase) async {
    localDatabase.typeDao.findAllTypes().forEach((types) async {
      for (var type in types) {
        DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref(
            "${FirebaseAuth.instance.currentUser?.uid}/types/${type.name}");
        await firebaseDatabase.set({"order": type.order});
      }
    });
    return 0;
  }

  static Future<int> migrateWeapons(FlutterDatabase localDatabase) async {
    localDatabase.weaponDao.findAllWeapons().forEach((weapons) async {
      for (var weapon in weapons) {
        DatabaseReference firebaseDatabase = FirebaseDatabase.instance
            .ref("${FirebaseAuth.instance.currentUser?.uid}/weapons")
            .push();
        await firebaseDatabase.set({
          "name": weapon.name,
          "order": weapon.order,
          "show": weapon.show,
        });
        migrateTrainings(weapon, firebaseDatabase.key!, localDatabase);
        migrateCompetition(weapon, firebaseDatabase.key!, localDatabase);
        //migrateProcedure(weapon, localDatabase);
        //migrateGoals(weapon, localDatabase);
      }
    });
    return 0;
  }

  static Future<int> migrateTrainings(
      Weapon weapon, String weaponId, FlutterDatabase localDatabase) async {
    localDatabase.trainingDao
        .findAllTrainingsForWeapon(weapon.id!)
        .forEach((trainings) async {
      for (var training in trainings) {
        DatabaseReference firebaseDatabase = FirebaseDatabase.instance
            .ref(
                "${FirebaseAuth.instance.currentUser?.uid}/weapons/$weaponId/trainings")
            .push();
        await firebaseDatabase.set({
          "date": training.date.toString(),
          "image": training.image,
          "indicator": training.indicator,
          "place": training.place,
          "kind": training.kind,
          "shotCount": training.shotCount,
          "shots": training.shots,
          "comment": training.comment
        });
      }
    });
    return 0;
  }

  static Future<int> migrateCompetition(
      Weapon weapon, String weaponId, FlutterDatabase localDatabase) async {
    localDatabase.competitionDao
        .findAllCompetitionForWeapon(weapon.id!)
        .forEach((competitions) async {
      for (var competition in competitions) {
        DatabaseReference firebaseDatabase = FirebaseDatabase.instance
            .ref(
                "${FirebaseAuth.instance.currentUser?.uid}/weapons/$weaponId/competition")
            .push();
        await firebaseDatabase.set({
          "date": competition.date.toString(),
          "image": competition.image,
          "place": competition.place,
          "kind": competition.kind,
          "shotCount": competition.shotCount,
          "shots": competition.shots,
          "comment": competition.comment
        });
      }
    });
    return 0;
  }

  static Future<int> migrateProcedure(
      Weapon weapon, String, weaponId, FlutterDatabase localDatabase) async {
    DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref(
        "${FirebaseAuth.instance.currentUser?.uid}/weapons/$weaponId/procedure");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await firebaseDatabase.set({
      "preparation": prefs.getString("${weapon.prefFile}_procedure_before"),
      "shot": prefs.getString("${weapon.prefFile}_procedure_shot")
    });
    return 0;
  }

  static Future<int> migrateGoals(
      Weapon weapon, String weaponId, FlutterDatabase localDatabase) async {
    DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref(
        "${FirebaseAuth.instance.currentUser?.uid}/weapons/$weaponId/goals");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await firebaseDatabase.set({
      "whole_40_jackpot":
          prefs.getString("${weapon.prefFile}_goalWhole_40_jackpot"),
      "whole_40_optimal":
          prefs.getString("${weapon.prefFile}_goalWhole_40_optimal"),
      "whole_40_real": prefs.getString("${weapon.prefFile}_goalWhole_40_real"),
      "whole_40_minimal":
          prefs.getString("${weapon.prefFile}_goalWhole_40_minimal"),
      "whole_40_chaos":
          prefs.getString("${weapon.prefFile}_goalWhole_40_chaos"),
      "whole_60_jackpot":
          prefs.getString("${weapon.prefFile}_goalWhole_60_jackpot"),
      "whole_60_optimal":
          prefs.getString("${weapon.prefFile}_goalWhole_60_optimal"),
      "whole_60_real": prefs.getString("${weapon.prefFile}_goalWhole_60_real"),
      "whole_60_minimal":
          prefs.getString("${weapon.prefFile}_goalWhole_60_minimal"),
      "whole_60_chaos":
          prefs.getString("${weapon.prefFile}_goalWhole_60_chaos"),
      "tenth_40_jackpot":
          prefs.getString("${weapon.prefFile}_goalTenth_40_jackpot"),
      "tenth_40_optimal":
          prefs.getString("${weapon.prefFile}_goalTenth_40_optimal"),
      "tenth_40_real": prefs.getString("${weapon.prefFile}_goalTenth_40_real"),
      "tenth_40_minimal":
          prefs.getString("${weapon.prefFile}_goalTenth_40_minimal"),
      "tenth_40_chaos":
          prefs.getString("${weapon.prefFile}_goalTenth_40_chaos"),
      "tenth_60_jackpot":
          prefs.getString("${weapon.prefFile}_goalTenth_40_chaos"),
      "tenth_60_optimal":
          prefs.getString("${weapon.prefFile}_goalTenth_60_optimal"),
      "tenth_60_real": prefs.getString("${weapon.prefFile}_goalTenth_60_real"),
      "tenth_60_minimal":
          prefs.getString("${weapon.prefFile}_goalTenth_60_minimal"),
      "tenth_60_chaos": prefs.getString("${weapon.prefFile}_goalTenth_60_chaos")
    });
    return 0;
  }

  ///
  /// General functions
  ///
  static Future<int> loadDefaultWeapons(WeaponDao weaponDao) async {
    log("Loading initial weapons.", name: "Migration");
    try {
      await weaponDao
          .insertWeapon(Weapon(1, "weapon_00", 0, "prefWeapon00", false));
      await weaponDao
          .insertWeapon(Weapon(2, "weapon_01", 1, "prefWeapon01", false));
      await weaponDao
          .insertWeapon(Weapon(3, "weapon_02", 2, "prefWeapon02", false));
      await weaponDao
          .insertWeapon(Weapon(4, "weapon_03", 3, "prefWeapon03", false));
      await weaponDao
          .insertWeapon(Weapon(5, "weapon_04", 4, "prefWeapon04", false));
      await weaponDao
          .insertWeapon(Weapon(6, "weapon_05", 5, "prefWeapon05", false));
      await weaponDao
          .insertWeapon(Weapon(7, "weapon_06", 6, "prefWeapon06", false));
      await weaponDao
          .insertWeapon(Weapon(8, "weapon_07", 7, "prefWeapon07", false));
      await weaponDao
          .insertWeapon(Weapon(9, "weapon_08", 8, "prefWeapon08", false));
      await weaponDao
          .insertWeapon(Weapon(10, "weapon_09", 9, "prefWeapon09", false));
      await weaponDao
          .insertWeapon(Weapon(11, "weapon_10", 10, "prefWeapon10", false));
      await weaponDao
          .insertWeapon(Weapon(12, "weapon_11", 11, "prefWeapon11", false));
      await weaponDao
          .insertWeapon(Weapon(13, "weapon_12", 12, "prefWeapon12", false));
      await weaponDao
          .insertWeapon(Weapon(14, "weapon_13", 13, "prefWeapon13", false));
      await weaponDao
          .insertWeapon(Weapon(15, "weapon_14", 14, "prefWeapon14", false));
      await weaponDao
          .insertWeapon(Weapon(16, "weapon_15", 15, "prefWeapon15", false));
      await weaponDao
          .insertWeapon(Weapon(17, "weapon_16", 16, "prefWeapon16", false));
      await weaponDao
          .insertWeapon(Weapon(18, "weapon_17", 17, "prefWeapon17", false));
      await weaponDao
          .insertWeapon(Weapon(19, "weapon_18", 18, "prefWeapon18", false));
      await weaponDao
          .insertWeapon(Weapon(20, "weapon_19", 19, "prefWeapon19", false));
      await weaponDao
          .insertWeapon(Weapon(21, "weapon_20", 20, "prefWeapon20", false));
      await weaponDao
          .insertWeapon(Weapon(22, "weapon_21", 21, "prefWeapon21", false));
      await weaponDao
          .insertWeapon(Weapon(23, "weapon_22", 22, "prefWeapon22", false));
      await weaponDao
          .insertWeapon(Weapon(24, "weapon_23", 23, "prefWeapon23", false));
      await weaponDao
          .insertWeapon(Weapon(25, "weapon_24", 24, "prefWeapon24", false));
      await weaponDao
          .insertWeapon(Weapon(26, "weapon_25", 25, "prefWeapon25", false));
      await weaponDao
          .insertWeapon(Weapon(27, "weapon_26", 26, "prefWeapon26", false));
      await weaponDao
          .insertWeapon(Weapon(28, "weapon_27", 27, "prefWeapon27", false));
      await weaponDao
          .insertWeapon(Weapon(29, "weapon_28", 28, "prefWeapon28", false));
      await weaponDao
          .insertWeapon(Weapon(30, "weapon_29", 29, "prefWeapon29", false));
      await weaponDao
          .insertWeapon(Weapon(31, "weapon_30", 30, "prefWeapon30", false));
      await weaponDao
          .insertWeapon(Weapon(32, "weapon_31", 31, "prefWeapon31", false));
      await weaponDao
          .insertWeapon(Weapon(33, "weapon_32", 32, "prefWeapon32", false));
      await weaponDao
          .insertWeapon(Weapon(34, "weapon_33", 33, "prefWeapon33", false));
      await weaponDao
          .insertWeapon(Weapon(35, "weapon_34", 34, "prefWeapon34", false));
      await weaponDao
          .insertWeapon(Weapon(36, "weapon_35", 35, "prefWeapon35", false));
      await weaponDao
          .insertWeapon(Weapon(37, "weapon_36", 36, "prefWeapon36", false));
      await weaponDao
          .insertWeapon(Weapon(38, "weapon_37", 37, "prefWeapon37", false));
      await weaponDao
          .insertWeapon(Weapon(39, "weapon_38", 38, "prefWeapon38", false));
      await weaponDao
          .insertWeapon(Weapon(40, "weapon_39", 39, "prefWeapon39", false));
      await weaponDao
          .insertWeapon(Weapon(41, "weapon_40", 40, "prefWeapon40", false));
      await weaponDao
          .insertWeapon(Weapon(42, "weapon_41", 41, "prefWeapon41", false));
      await weaponDao
          .insertWeapon(Weapon(43, "weapon_42", 42, "prefWeapon42", false));
      await weaponDao
          .insertWeapon(Weapon(44, "weapon_43", 43, "prefWeapon43", false));
      await weaponDao
          .insertWeapon(Weapon(45, "weapon_44", 44, "prefWeapon44", false));
      await weaponDao
          .insertWeapon(Weapon(46, "weapon_45", 45, "prefWeapon45", false));
      await weaponDao
          .insertWeapon(Weapon(47, "weapon_46", 46, "prefWeapon46", false));
      await weaponDao
          .insertWeapon(Weapon(48, "weapon_47", 47, "prefWeapon47", false));
      await weaponDao
          .insertWeapon(Weapon(49, "weapon_48", 48, "prefWeapon48", false));
      await weaponDao
          .insertWeapon(Weapon(50, "weapon_49", 49, "prefWeapon49", false));
      await weaponDao
          .insertWeapon(Weapon(51, "weapon_50", 50, "prefWeapon50", false));
      await weaponDao
          .insertWeapon(Weapon(52, "weapon_51", 51, "prefWeapon51", false));
      await weaponDao
          .insertWeapon(Weapon(53, "weapon_52", 52, "prefWeapon52", false));
      await weaponDao
          .insertWeapon(Weapon(54, "weapon_53", 53, "prefWeapon53", false));
      await weaponDao
          .insertWeapon(Weapon(55, "weapon_54", 54, "prefWeapon54", false));
      await weaponDao
          .insertWeapon(Weapon(56, "weapon_55", 55, "prefWeapon55", false));
      await weaponDao
          .insertWeapon(Weapon(57, "weapon_56", 56, "prefWeapon56", false));
      await weaponDao
          .insertWeapon(Weapon(58, "weapon_57", 57, "prefWeapon57", false));

      log("Loading initial weapons finished.", name: "Migration");
      return 0;
    } on Exception catch (_) {
      log("Default weapons already there.");
      return 1;
    }
  }

  static Future<int> loadDefaultTypes(TypeDao typeDao) async {
    log("Loading initial types.", name: "Migration");

    try {
      await typeDao.insertGroup(Type(1, "type_00", 0));
      await typeDao.insertGroup(Type(2, "type_01", 1));
      await typeDao.insertGroup(Type(3, "type_02", 2));
      await typeDao.insertGroup(Type(4, "type_03", 3));
      await typeDao.insertGroup(Type(5, "type_04", 4));

      log("Loading initial types finished.", name: "Migration");
      return 0;
    } on Exception catch (_) {
      log("Default types already there.");
      return 1;
    }
  }
}
