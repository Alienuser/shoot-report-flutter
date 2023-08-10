import 'dart:developer';
import 'package:shoot_report/models/type.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/type_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/database.dart';

class AppMigration {
  ///
  /// Migration functions
  ///

  static void migrate_1_6_1(FlutterDatabase database) {
    // Migrate the database
    addTypeTable(database);
    addTypeColumn(database);
    loadDefaultTypes(database.typeDao);
    categorizeWeapons(database);
    addNewWeapons(database);
  }

  ///
  /// Helper functions
  ///

  static void addTypeTable(FlutterDatabase database) async {
    await database.database.execute(
        "CREATE TABLE `Type` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `order` INTEGER NOT NULL);");
  }

  static void addTypeColumn(FlutterDatabase database) async {
    await database.database
        .execute("ALTER TABLE `Weapon` ADD COLUMN `typeId` INTEGER DEFAULT 0;");
  }

  static void categorizeWeapons(FlutterDatabase database) async {
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 1;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 2;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 3;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 4;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 5;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 2 WHERE id = 6;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 2 WHERE id = 7;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 8;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 9;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 10;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 2 WHERE id = 11;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 5 WHERE id = 12;");
    await database.database
        .execute("UPDATE `Weapon` SET typeId = 2 WHERE id = 13;");
  }

  static void addNewWeapons(FlutterDatabase database) async {
    await database.weaponDao
        .insertWeapon(Weapon(13, "weapon_12", 12, "prefWeapon12", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(14, "weapon_13", 13, "prefWeapon13", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(15, "weapon_14", 14, "prefWeapon14", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(16, "weapon_15", 15, "prefWeapon15", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(17, "weapon_16", 16, "prefWeapon16", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(18, "weapon_17", 17, "prefWeapon17", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(19, "weapon_18", 18, "prefWeapon18", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(20, "weapon_19", 19, "prefWeapon19", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(21, "weapon_20", 20, "prefWeapon20", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(22, "weapon_21", 21, "prefWeapon21", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(23, "weapon_22", 22, "prefWeapon22", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(24, "weapon_23", 23, "prefWeapon23", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(25, "weapon_24", 24, "prefWeapon24", 1, false));
    await database.weaponDao
        .insertWeapon(Weapon(26, "weapon_25", 25, "prefWeapon25", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(27, "weapon_26", 26, "prefWeapon26", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(28, "weapon_27", 27, "prefWeapon27", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(29, "weapon_28", 28, "prefWeapon28", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(30, "weapon_29", 29, "prefWeapon29", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(31, "weapon_30", 30, "prefWeapon30", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(32, "weapon_31", 31, "prefWeapon31", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(33, "weapon_32", 32, "prefWeapon32", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(34, "weapon_33", 33, "prefWeapon33", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(35, "weapon_34", 34, "prefWeapon34", 2, false));
    await database.weaponDao
        .insertWeapon(Weapon(36, "weapon_35", 35, "prefWeapon35", 3, false));
    await database.weaponDao
        .insertWeapon(Weapon(37, "weapon_36", 36, "prefWeapon36", 3, false));
    await database.weaponDao
        .insertWeapon(Weapon(38, "weapon_37", 37, "prefWeapon37", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(39, "weapon_38", 38, "prefWeapon38", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(40, "weapon_39", 39, "prefWeapon39", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(41, "weapon_40", 40, "prefWeapon40", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(42, "weapon_41", 41, "prefWeapon41", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(43, "weapon_42", 42, "prefWeapon42", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(44, "weapon_43", 43, "prefWeapon43", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(45, "weapon_44", 44, "prefWeapon44", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(46, "weapon_45", 45, "prefWeapon45", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(47, "weapon_46", 46, "prefWeapon46", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(48, "weapon_47", 47, "prefWeapon47", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(49, "weapon_48", 48, "prefWeapon48", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(50, "weapon_49", 49, "prefWeapon49", 4, false));
    await database.weaponDao
        .insertWeapon(Weapon(51, "weapon_50", 50, "prefWeapon50", 5, false));
    await database.weaponDao
        .insertWeapon(Weapon(52, "weapon_51", 51, "prefWeapon51", 5, false));
    await database.weaponDao
        .insertWeapon(Weapon(53, "weapon_52", 52, "prefWeapon52", 5, false));
    await database.weaponDao
        .insertWeapon(Weapon(54, "weapon_53", 53, "prefWeapon53", 5, false));
    await database.weaponDao
        .insertWeapon(Weapon(55, "weapon_54", 54, "prefWeapon54", 5, false));
    await database.weaponDao
        .insertWeapon(Weapon(56, "weapon_55", 55, "prefWeapon55", 5, false));
    await database.weaponDao
        .insertWeapon(Weapon(57, "weapon_56", 56, "prefWeapon56", 5, false));
  }

  ///
  /// General functions
  ///
  static void loadDefaultWeapons(WeaponDao weaponDao) async {
    log("Loading initial weapons.", name: "Migration");
    try {
      await weaponDao
          .insertWeapon(Weapon(1, "weapon_00", 0, "prefWeapon00", 1, false));
      await weaponDao
          .insertWeapon(Weapon(2, "weapon_01", 1, "prefWeapon01", 1, false));
      await weaponDao
          .insertWeapon(Weapon(3, "weapon_02", 2, "prefWeapon02", 1, false));
      await weaponDao
          .insertWeapon(Weapon(4, "weapon_03", 3, "prefWeapon03", 1, false));
      await weaponDao
          .insertWeapon(Weapon(5, "weapon_04", 4, "prefWeapon04", 1, false));
      await weaponDao
          .insertWeapon(Weapon(6, "weapon_05", 5, "prefWeapon05", 2, false));
      await weaponDao
          .insertWeapon(Weapon(7, "weapon_06", 6, "prefWeapon06", 2, false));
      await weaponDao
          .insertWeapon(Weapon(8, "weapon_07", 7, "prefWeapon07", 1, false));
      await weaponDao
          .insertWeapon(Weapon(9, "weapon_08", 8, "prefWeapon08", 1, false));
      await weaponDao
          .insertWeapon(Weapon(10, "weapon_09", 9, "prefWeapon09", 1, false));
      await weaponDao
          .insertWeapon(Weapon(11, "weapon_10", 10, "prefWeapon10", 2, false));
      await weaponDao
          .insertWeapon(Weapon(12, "weapon_11", 11, "prefWeapon11", 5, false));
      await weaponDao
          .insertWeapon(Weapon(13, "weapon_12", 12, "prefWeapon12", 2, false));
      await weaponDao
          .insertWeapon(Weapon(14, "weapon_13", 13, "prefWeapon13", 1, false));
      await weaponDao
          .insertWeapon(Weapon(15, "weapon_14", 14, "prefWeapon14", 1, false));
      await weaponDao
          .insertWeapon(Weapon(16, "weapon_15", 15, "prefWeapon15", 1, false));
      await weaponDao
          .insertWeapon(Weapon(17, "weapon_16", 16, "prefWeapon16", 1, false));
      await weaponDao
          .insertWeapon(Weapon(18, "weapon_17", 17, "prefWeapon17", 1, false));
      await weaponDao
          .insertWeapon(Weapon(19, "weapon_18", 18, "prefWeapon18", 1, false));
      await weaponDao
          .insertWeapon(Weapon(20, "weapon_19", 19, "prefWeapon19", 1, false));
      await weaponDao
          .insertWeapon(Weapon(21, "weapon_20", 20, "prefWeapon20", 1, false));
      await weaponDao
          .insertWeapon(Weapon(22, "weapon_21", 21, "prefWeapon21", 1, false));
      await weaponDao
          .insertWeapon(Weapon(23, "weapon_22", 22, "prefWeapon22", 1, false));
      await weaponDao
          .insertWeapon(Weapon(24, "weapon_23", 23, "prefWeapon23", 1, false));
      await weaponDao
          .insertWeapon(Weapon(25, "weapon_24", 24, "prefWeapon24", 1, false));
      await weaponDao
          .insertWeapon(Weapon(26, "weapon_25", 25, "prefWeapon25", 2, false));
      await weaponDao
          .insertWeapon(Weapon(27, "weapon_26", 26, "prefWeapon26", 2, false));
      await weaponDao
          .insertWeapon(Weapon(28, "weapon_27", 27, "prefWeapon27", 2, false));
      await weaponDao
          .insertWeapon(Weapon(29, "weapon_28", 28, "prefWeapon28", 2, false));
      await weaponDao
          .insertWeapon(Weapon(30, "weapon_29", 29, "prefWeapon29", 2, false));
      await weaponDao
          .insertWeapon(Weapon(31, "weapon_30", 30, "prefWeapon30", 2, false));
      await weaponDao
          .insertWeapon(Weapon(32, "weapon_31", 31, "prefWeapon31", 2, false));
      await weaponDao
          .insertWeapon(Weapon(33, "weapon_32", 32, "prefWeapon32", 2, false));
      await weaponDao
          .insertWeapon(Weapon(34, "weapon_33", 33, "prefWeapon33", 2, false));
      await weaponDao
          .insertWeapon(Weapon(35, "weapon_34", 34, "prefWeapon34", 2, false));
      await weaponDao
          .insertWeapon(Weapon(36, "weapon_35", 35, "prefWeapon35", 3, false));
      await weaponDao
          .insertWeapon(Weapon(37, "weapon_36", 36, "prefWeapon36", 3, false));
      await weaponDao
          .insertWeapon(Weapon(38, "weapon_37", 37, "prefWeapon37", 4, false));
      await weaponDao
          .insertWeapon(Weapon(39, "weapon_38", 38, "prefWeapon38", 4, false));
      await weaponDao
          .insertWeapon(Weapon(40, "weapon_39", 39, "prefWeapon39", 4, false));
      await weaponDao
          .insertWeapon(Weapon(41, "weapon_40", 40, "prefWeapon40", 4, false));
      await weaponDao
          .insertWeapon(Weapon(42, "weapon_41", 41, "prefWeapon41", 4, false));
      await weaponDao
          .insertWeapon(Weapon(43, "weapon_42", 42, "prefWeapon42", 4, false));
      await weaponDao
          .insertWeapon(Weapon(44, "weapon_43", 43, "prefWeapon43", 4, false));
      await weaponDao
          .insertWeapon(Weapon(45, "weapon_44", 44, "prefWeapon44", 4, false));
      await weaponDao
          .insertWeapon(Weapon(46, "weapon_45", 45, "prefWeapon45", 4, false));
      await weaponDao
          .insertWeapon(Weapon(47, "weapon_46", 46, "prefWeapon46", 4, false));
      await weaponDao
          .insertWeapon(Weapon(48, "weapon_47", 47, "prefWeapon47", 4, false));
      await weaponDao
          .insertWeapon(Weapon(49, "weapon_48", 48, "prefWeapon48", 4, false));
      await weaponDao
          .insertWeapon(Weapon(50, "weapon_49", 49, "prefWeapon49", 4, false));
      await weaponDao
          .insertWeapon(Weapon(51, "weapon_50", 50, "prefWeapon50", 5, false));
      await weaponDao
          .insertWeapon(Weapon(52, "weapon_51", 51, "prefWeapon51", 5, false));
      await weaponDao
          .insertWeapon(Weapon(53, "weapon_52", 52, "prefWeapon52", 5, false));
      await weaponDao
          .insertWeapon(Weapon(54, "weapon_53", 53, "prefWeapon53", 5, false));
      await weaponDao
          .insertWeapon(Weapon(55, "weapon_54", 54, "prefWeapon54", 5, false));
      await weaponDao
          .insertWeapon(Weapon(56, "weapon_55", 55, "prefWeapon55", 5, false));
      await weaponDao
          .insertWeapon(Weapon(57, "weapon_56", 56, "prefWeapon56", 5, false));

      log("Loading initial weapons finished.", name: "Migration");
    } on Exception catch (_) {
      log("Default weapons already there.");
    }
  }

  static void loadDefaultTypes(TypeDao typeDao) async {
    log("Loading initial types.", name: "Migration");

    try {
      await typeDao.insertGroup(Type(1, "type_00", 0));
      await typeDao.insertGroup(Type(2, "type_01", 1));
      await typeDao.insertGroup(Type(3, "type_02", 2));
      await typeDao.insertGroup(Type(4, "type_03", 3));
      await typeDao.insertGroup(Type(5, "type_04", 4));

      log("Loading initial types finished.", name: "Migration");
    } on Exception catch (_) {
      log("Default types already there.");
    }
  }
}
