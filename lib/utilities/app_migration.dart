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

  static void addTypeTable(FlutterDatabase database) {
    database.database.execute(
        "CREATE TABLE `Type` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `order` INTEGER NOT NULL);");
  }

  static void addTypeColumn(FlutterDatabase database) {
    database.database
        .execute("ALTER TABLE `Weapon` ADD COLUMN `typeId` INTEGER;");
  }

  static void categorizeWeapons(FlutterDatabase database) {
    database.database.execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 1;");
    database.database.execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 2;");
    database.database.execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 3;");
    database.database.execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 4;");
    database.database.execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 5;");
    database.database.execute("UPDATE `Weapon` SET typeId = 2 WHERE id = 6;");
    database.database.execute("UPDATE `Weapon` SET typeId = 2 WHERE id = 7;");
    database.database.execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 8;");
    database.database.execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 9;");
    database.database.execute("UPDATE `Weapon` SET typeId = 1 WHERE id = 10;");
    database.database.execute("UPDATE `Weapon` SET typeId = 2 WHERE id = 11;");
    database.database.execute("UPDATE `Weapon` SET typeId = 5 WHERE id = 12;");
    database.database.execute("UPDATE `Weapon` SET typeId = 2 WHERE id = 13;");
  }

  static void addNewWeapons(FlutterDatabase database) {}

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
      await typeDao.insertGroup(Type(6, "type_05", 5));
      await typeDao.insertGroup(Type(7, "type_06", 6));

      log("Loading initial types finished.", name: "Migration");
    } on Exception catch (_) {
      log("Default types already there.");
    }
  }
}
