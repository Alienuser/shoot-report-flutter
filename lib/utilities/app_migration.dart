import 'dart:convert';
import 'dart:io';
import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';

class AppMigration {
  static void doDatabaseMigration(WeaponDao weaponDao, TrainingDao trainingDao,
      CompetitionDao competitionDao) async {
    if (Platform.isAndroid) {
      try {
        await openDatabase(
          "report.db",
          onOpen: (db) async {
            print(db.path);
            List<Map> weapons = await db.rawQuery('SELECT * FROM rifle_table');

            for (var i = 0; i < weapons.length; i++) {
              if (i < 10) {
                Weapon weapon = Weapon(
                    weapons[i]["id"],
                    "weapon_0$i",
                    weapons[i]["order"],
                    "prefWeapon0$i",
                    (weapons[i]["show"] == 0) ? false : true);
                weaponDao.insertWeapon(weapon);
              } else {
                Weapon weapon = Weapon(
                    weapons[i]["id"],
                    "weapon_$i",
                    weapons[i]["order"],
                    "prefWeapon$i",
                    (weapons[i]["show"] == 0) ? false : true);
                weaponDao.insertWeapon(weapon);
              }
            }

            List<Map> trainings =
                await db.rawQuery('SELECT * FROM training_table');
            for (var element in trainings) {
              trainingDao.insertTraining(Training(
                  null,
                  DateTime.fromMillisecondsSinceEpoch(element["date"]),
                  element["image"],
                  element["indicator"],
                  element["place"],
                  element["training"],
                  element["shoot_count"],
                  jsonDecode(element["shoots"].replaceAll(".0", "")),
                  element["report"],
                  element["rifleId"]));
            }

            List<Map> competitions =
                await db.rawQuery('SELECT * FROM competition_table');
            for (var element in competitions) {
              competitionDao.insertCompetition(Competition(
                null,
                DateTime.fromMillisecondsSinceEpoch(element["date"]),
                element["image"],
                element["place"],
                element["kind"],
                element["shoot_count"],
                jsonDecode(element["shoots"].replaceAll(".0", "")),
                element["report"],
                element["rifleId"],
              ));
            }
          },
        );
      } catch (_) {
        //_loadDefaultWeapons(weaponDao);
      }
    } else if (Platform.isIOS) {
      try {
        await openDatabase(
          "${(await getApplicationSupportDirectory()).path}/shoot_report.sqlite",
          onOpen: (db) async {
            print(db.path);
            List<Map> list = await db.rawQuery('SELECT * from ZRIFLE;');
            print(list);
          },
        );
      } catch (_) {
        print("Doing initial load");
        _loadDefaultWeapons(weaponDao);
      }
    }
  }

  static void doSharedPrefMigration() async {
    if (Platform.isAndroid) {
      var path = (await getApplicationDocumentsDirectory()).parent.path +
          "/shared_prefs/preference_rifle_1.xml";
      var file = File(path);
      var document = XmlDocument.parse(file.readAsStringSync());
      final titles = document.findAllElements('string');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      for (var element in titles) {
        if (element.attributes.first.value == "pref_plan_during") {
          prefs.setString("prefWeapon00_procedure_shot", element.text);
        } else if (element.attributes.first.value == "pref_plan_before") {
          prefs.setString("prefWeapon00_procedure_before", element.text);
        }

        print('${element.attributes.first.value}->${element.text}');
      }
    } else if (Platform.isIOS) {
      var path = ((await getLibraryDirectory()).path +
          "/Preferences/de.famprobst.report.plist");
      var file = File(path);

      NativeSharedPreferences prefs =
          await NativeSharedPreferences.getInstance();
      print(prefs.getString('goals_whole_60_optimal_1'));
    }
  }

  static void _loadDefaultWeapons(WeaponDao weaponDao) async {
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_00", 0, "prefWeapon00", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_01", 1, "prefWeapon01", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_02", 2, "prefWeapon02", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_03", 3, "prefWeapon03", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_04", 4, "prefWeapon04", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_05", 5, "prefWeapon05", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_06", 6, "prefWeapon06", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_07", 7, "prefWeapon07", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_08", 8, "prefWeapon08", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_09", 9, "prefWeapon09", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_10", 10, "prefWeapon10", true));
    await weaponDao
        .insertWeapon(Weapon(null, "weapon_11", 11, "prefWeapon11", true));
  }
}
