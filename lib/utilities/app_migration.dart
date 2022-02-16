import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plist_parser/plist_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

class AppMigration {
  static List<String> weaponIds = [];

  static void doDatabaseMigration(FlutterDatabase database) async {
    if (Platform.isAndroid) {
      try {
        await openDatabase(
          "report.db",
          onOpen: (db) async {
            log(db.path, name: "Migration-Android");

            log("Migrate Weapons", name: "Migration-Android");
            List<Map> weapons = await db.rawQuery('SELECT * FROM rifle_table');
            for (var i = 0; i < weapons.length; i++) {
              if (i < 10) {
                Weapon weapon = Weapon(null, "weapon_0$i", weapons[i]["order"],
                    "prefWeapon0$i", (weapons[i]["show"] == 0) ? false : true);
                database.weaponDao.insertWeapon(weapon);
              } else {
                Weapon weapon = Weapon(null, "weapon_$i", weapons[i]["order"],
                    "prefWeapon$i", (weapons[i]["show"] == 0) ? false : true);
                database.weaponDao.insertWeapon(weapon);
              }
            }

            log("Migrate Trainings", name: "Migration-Android");
            List<Map> trainings =
                await db.rawQuery('SELECT * FROM training_table');
            for (var element in trainings) {
              database.trainingDao.insertTraining(Training(
                  null,
                  DateTime.fromMillisecondsSinceEpoch(element["date"]),
                  element["image"] ?? "",
                  element["indicator"] ?? "",
                  element["place"] ?? "",
                  element["training"] ?? "",
                  element["shoot_count"] ?? "",
                  jsonDecode((element["shoots"] ?? "").replaceAll(".0", "")),
                  element["report"] ?? "",
                  element["rifleId"] ?? ""));
            }

            log("Migrate Competitions", name: "Migration-Android");
            List<Map> competitions =
                await db.rawQuery('SELECT * FROM competition_table');
            for (var element in competitions) {
              database.competitionDao.insertCompetition(Competition(
                null,
                DateTime.fromMillisecondsSinceEpoch((element["date"] ?? "")),
                element["image"] ?? "",
                element["place"] ?? "",
                element["kind"] ?? "",
                element["shoot_count"] ?? "",
                jsonDecode((element["shoots"] ?? "").replaceAll(".0", "")),
                element["report"] ?? "",
                element["rifleId"] ?? "",
              ));
            }
          },
        );
      } catch (_) {
        _loadDefaultWeapons(database);
      }
    } else if (Platform.isIOS) {
      try {
        await openDatabase(
          "${(await getApplicationSupportDirectory()).path}/shoot_report.sqlite",
          onOpen: (db) async {
            log(db.path, name: "Migration-iOS");

            log("Migrate Weapons", name: "Migration-iOS");
            List<Map> weapons = await db.rawQuery('SELECT * from ZRIFLE;');
            for (var i = 0; i < weapons.length; i++) {
              weaponIds.add(UuidValue.fromByteList(weapons[i]["ZID"]).uuid);
              if (i < 10) {
                Weapon weapon = Weapon(null, "weapon_0$i", weapons[i]["ZORDER"],
                    "prefWeapon0$i", (weapons[i]["ZSHOW"] == 0) ? false : true);
                database.weaponDao.insertWeapon(weapon);
              } else {
                Weapon weapon = Weapon(null, "weapon_$i", weapons[i]["ZORDER"],
                    "prefWeapon$i", (weapons[i]["ZSHOW"] == 0) ? false : true);
                database.weaponDao.insertWeapon(weapon);
              }
            }

            log("Migrate Trainings", name: "Migration-iOS");
            List<Map> trainings = await db.rawQuery('SELECT * from ZTRAINING;');
            for (var element in trainings) {
              Training training = Training(
                null,
                DateTime.fromMicrosecondsSinceEpoch(int.tryParse(
                        ((element["ZDATE"] ?? 0) + 978307200)
                            .toString()
                            .replaceAll(".", "")) ??
                    0),
                element["ZIMAGE"] ?? "",
                helperGetIndicator(element["ZINDICATOR"] ?? 0),
                element["ZPLACE"] ?? "",
                helperGetTrainingKind(element["ZTRAINING"] ?? ""),
                element["ZSHOOT_COUNT"] ?? 0,
                jsonDecode(helperGetShotList(element["ZSHOOTS"])),
                element["ZREPORT"] ?? "",
                helperGetRifleId(element["ZRIFLEID"]),
              );
              database.trainingDao.insertTraining(training);
            }

            log("Migrate Competitions", name: "Migration-iOS");
            List<Map> competitions =
                await db.rawQuery('SELECT * from ZCOMPETITION;');
            for (var element in competitions) {
              Competition competition = Competition(
                null,
                DateTime.fromMicrosecondsSinceEpoch(int.tryParse(
                        ((element["ZDATE"] ?? 0) + 978307200)
                            .toString()
                            .replaceAll(".", "")) ??
                    0),
                element["ZIMAGE"] ?? "",
                element["ZPLACE"] ?? "",
                helperGetCompetitionKind(element["ZKIND"] ?? ""),
                element["ZSHOOT_COUNT"] ?? "",
                jsonDecode(helperGetShotList(element["ZSHOOTS"])),
                element["ZREPORT"] ?? "",
                helperGetRifleId(element["ZRIFLEID"]),
              );
              database.competitionDao.insertCompetition(competition);
            }
          },
        );
      } catch (error) {
        _loadDefaultWeapons(database);
      }
    }
  }

  static void doSharedPrefMigration() async {
    if (Platform.isAndroid) {
      log("Migrate SharedPrefs", name: "Migration-Android");
      try {
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

          log("${element.attributes.first.value}->${element.text}",
              name: "Migration-Android");
        }
      } catch (_) {
        log("No SharedPrefs.", name: "Migration-Android");
      }
    } else if (Platform.isIOS) {
      log("Migrate SharedPrefs", name: "Migration-iOS");
      try {
        NativeSharedPreferences nativePref =
            await NativeSharedPreferences.getInstance();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        for (var i = 1; i < 13; i++) {
          if (i < 10) {
            prefs.setString("prefWeapon0${i - 1}_goalWhole_60_optimal",
                nativePref.getString('goals_whole_60_optimal_$i') ?? "");
          } else {
            prefs.setString("prefWeapon${i - 1}_goalWhole_60_optimal",
                nativePref.getString('goals_whole_60_optimal_$i') ?? "");
          }
        }
      } catch (_) {
        log("No SharedPrefs.", name: "Migration-iOS");
      }
    }
  }

  static void _loadDefaultWeapons(FlutterDatabase database) async {
    log("Loading initial weapons.", name: "Migration");

    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_00", 0, "prefWeapon00", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_01", 1, "prefWeapon01", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_02", 2, "prefWeapon02", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_03", 3, "prefWeapon03", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_04", 4, "prefWeapon04", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_05", 5, "prefWeapon05", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_06", 6, "prefWeapon06", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_07", 7, "prefWeapon07", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_08", 8, "prefWeapon08", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_09", 9, "prefWeapon09", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_10", 10, "prefWeapon10", true));
    await database.weaponDao
        .insertWeapon(Weapon(null, "weapon_11", 11, "prefWeapon11", true));
  }

  static int helperGetIndicator(String indicator) {
    switch (indicator) {
      case "😧":
        return 0;
      case "🙁":
        return 1;
      case "🙂":
        return 2;
      case "😁":
        return 3;
      default:
        return 0;
    }
  }

  static String helperGetTrainingKind(String kind) {
    switch (kind) {
      case "training_add_kind_setup":
        return tr("training_kind_setup");
      case "training_add_kind_positioningSetUp":
        return tr("training_kind_positioning");
      case "training_add_kind_zeroPoint":
        return tr("training_kind_zeropoint");
      case "training_add_kind_breathing":
        return tr("training_kind_breathing");
      case "training_add_kind_aiming":
        return tr("training_kind_aiming");
      case "training_add_kind_trigger":
        return tr("training_kind_trigger");
      case "training_add_kind_coordination":
        return tr("training_kind_coordination");
      case "training_add_kind_phaseTraining":
        return tr("training_kind_phase");
      case "training_add_kind_leftPositioning":
        return tr("training_kind_left");
      case "training_add_kind_performanceTraining":
        return tr("training_kind_performance");
      case "training_add_kind_competitionTraining":
        return tr("training_kind_competition");
      case "training_add_kind_finalTraining":
        return tr("training_kind_final");
      case "training_add_kind_other":
        return tr("training_kind_other");
      default:
        return tr("training_kind_setup");
    }
  }

  static String helperGetCompetitionKind(String kind) {
    switch (kind) {
      case "competition_add_kind_league":
        return tr("competition_kind_league");
      case "competition_add_kind_round":
        return tr("competition_kind_round");
      case "competition_add_kind_championship":
        return tr("competition_kind_championship");
      case "competition_add_kind_control":
        return tr("competition_kind_control");
      case "competition_add_kind_other":
        return tr("competition_kind_other");
      default:
        return tr("competition_kind_league");
    }
  }

  static int helperGetRifleId(Uint8List rifleId) {
    String uuid = UuidValue.fromByteList(rifleId).uuid;
    return weaponIds.indexWhere((element) => element == uuid) + 1;
  }

  static String helperGetShotList(Uint8List list) {
    var test = PlistParser().parseBytes(list);
    List objectList = test["\$objects"];
    objectList.removeAt(0);
    objectList.removeAt(0);
    objectList.removeLast();
    return objectList.toString().replaceAll(".0", "");
  }
}
