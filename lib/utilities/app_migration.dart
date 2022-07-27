import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/database.dart';
import 'package:shoot_report/utilities/plist_parser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

class AppMigration {
  static List<String> weaponIds = [];

  ///
  /// Migration functions
  ///

  static void migrate_1_5_0(FlutterDatabase database) {
    if (Platform.isAndroid) {
      // Migrate the database
      doDatabaseMigration(database);
      // Migrate the shared preferences
      doSharedPrefMigration();
      // Logging
      log("Migrate to 1.5.0");
    }
  }

  static void migrate_1_5_1(FlutterDatabase database) {
    if (Platform.isIOS) {
      // Remove all weapons
      removeOldData(database);
      // Migrate the database
      doDatabaseMigration(database);
      // Migrate the shared preferences
      doSharedPrefMigration();
      // Logging
      log("Migrate to 1.5.1");
    }
  }

  ///
  /// Helper functions
  ///

  static void removeOldData(FlutterDatabase database) {
    database.database.delete("weapon");
    database.database.delete("sqlite_sequence");
  }

  ///
  /// ------------------------------------
  ///

  static void doDatabaseMigration(FlutterDatabase database) async {
    if (Platform.isAndroid) {
      try {
        await openDatabase(
          "report.db",
          onOpen: (db) async {
            log(db.path, name: "Migration-Android");

            log("Migrate Weapons", name: "Migration-Android");
            List<Map> weapons =
                await db.rawQuery("SELECT * FROM rifle_table Order by \"id\";");
            for (var i = 0; i < weapons.length; i++) {
              Weapon weapon = Weapon(
                  null,
                  "weapon_${i < 10 ? "0$i" : i}",
                  weapons[i]["order"],
                  "prefWeapon${i < 10 ? "0$i" : i}",
                  (weapons[i]["show"] == 0) ? false : true);
              database.weaponDao.insertWeapon(weapon);
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
            List<Map> weapons =
                await db.rawQuery("SELECT * from ZRIFLE Order by \"Z_PK\";");
            for (var i = 0; i < weapons.length; i++) {
              weaponIds.add(UuidValue.fromByteList(weapons[i]["ZID"]).uuid);
              Weapon weapon = Weapon(
                  null,
                  "weapon_${i < 10 ? "0$i" : i}",
                  weapons[i]["ZORDER"],
                  "prefWeapon${i < 10 ? "0$i" : i}",
                  (weapons[i]["ZSHOW"] == 0) ? false : true);
              database.weaponDao.insertWeapon(weapon);
            }

            log("Migrate Trainings", name: "Migration-iOS");
            List<Map> trainings = await db.rawQuery('SELECT * from ZTRAINING;');
            for (var element in trainings) {
              var date = DateTime.now();
              if (element["ZDATE"].toString().contains(".")) {
                date = DateTime.fromMicrosecondsSinceEpoch(int.tryParse(
                        ((element["ZDATE"] ?? 0) + 978307200)
                            .toString()
                            .replaceAll(".", "")) ??
                    0);
              } else {
                date = DateTime.fromMicrosecondsSinceEpoch(int.tryParse(
                        ((double.parse("${element["ZDATE"]}.716835")) +
                                978307200)
                            .toString()
                            .replaceAll(".", "")) ??
                    0);
              }

              Training training = Training(
                null,
                date,
                element["ZIMAGE"] ?? "",
                helperGetIndicator(element["ZINDICATOR"] ?? 0),
                element["ZPLACE"] ?? "",
                helperGetTrainingKind(element["ZTRAINING"] ?? ""),
                element["ZSHOOT_COUNT"] ?? 0,
                jsonDecode(helperGetShotList(element["ZSHOOTS"] ?? [])),
                element["ZREPORT"] ?? "",
                helperGetRifleId(element["ZRIFLEID"]),
              );
              database.trainingDao.insertTraining(training);
            }

            log("Migrate Competitions", name: "Migration-iOS");
            List<Map> competitions =
                await db.rawQuery('SELECT * from ZCOMPETITION;');
            for (var element in competitions) {
              var date = DateTime.now();
              if (element["ZDATE"].toString().contains(".")) {
                date = DateTime.fromMicrosecondsSinceEpoch(int.tryParse(
                        ((element["ZDATE"] ?? 0) + 978307200)
                            .toString()
                            .replaceAll(".", "")) ??
                    0);
              } else {
                date = DateTime.fromMicrosecondsSinceEpoch(int.tryParse(
                        ((double.parse("${element["ZDATE"]}.716835")) +
                                978307200)
                            .toString()
                            .replaceAll(".", "")) ??
                    0);
              }

              Competition competition = Competition(
                null,
                date,
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        log("Migrate User Data", name: "Migration-Android");
        var path =
            "${(await getApplicationDocumentsDirectory()).parent.path}/shared_prefs/activity.ActivityMasterData.xml";
        var file = File(path);
        var document = XmlDocument.parse(file.readAsStringSync());
        final titles = document.findAllElements('string');

        for (var element in titles) {
          if (element.attributes.first.value == "masterData_Name") {
            prefs.setString("data_person_name", element.text);
          } else if (element.attributes.first.value == "masterData_Age") {
            prefs.setString("data_person_age", element.text);
          } else if (element.attributes.first.value == "masterData_Size") {
            prefs.setString("data_person_height", element.text);
          } else if (element.attributes.first.value ==
              "masterData_Association1") {
            prefs.setString("data_person_club_1", element.text);
          } else if (element.attributes.first.value ==
              "masterData_Association2") {
            prefs.setString("data_person_club_2", element.text);
          } else if (element.attributes.first.value == "masterData_Trainer") {
            prefs.setString("data_person_trainer", element.text);
          } else if (element.attributes.first.value ==
              "masterData_TrainerMail") {
            prefs.setString("data_person_trainer_mail", element.text);
          } else if (element.attributes.first.value == "masterData_Squad") {
            prefs.setString("data_person_squadtrainer", element.text);
          } else if (element.attributes.first.value == "masterData_SquadMail") {
            prefs.setString("data_person_squadtrainer_mail", element.text);
          } else if (element.attributes.first.value == "pref_data_device") {
            prefs.setString("data_device", element.text);
          }
        }
      } catch (_) {
        log("No SharedPrefs. for user data.", name: "Migration-Android");
      }

      try {
        log("Migrate User Rifle Data", name: "Migration-Android");
        var path =
            "${(await getApplicationDocumentsDirectory()).parent.path}/shared_prefs/de.famprobst.report_preferences.xml";
        var file = File(path);
        var document = XmlDocument.parse(file.readAsStringSync());
        final titles = document.findAllElements('string');

        for (var element in titles) {
          if (element.attributes.first.value == "pref_data_device") {
            prefs.setString("data_device", element.text);
          }
        }
      } catch (_) {
        log("No SharedPrefs. for user rifle data.", name: "Migration-Android");
      }

      log("Migrate weapon data", name: "Migration-Android");
      for (var i = 1; i < 13; i++) {
        try {
          var path =
              "${(await getApplicationDocumentsDirectory()).parent.path}/shared_prefs/preference_rifle_$i.xml";
          var file = File(path);
          var document = XmlDocument.parse(file.readAsStringSync());
          final titles = document.findAllElements('string');

          for (var element in titles) {
            if (element.attributes.first.value == "pref_plan_during") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_procedure_shot",
                  element.text);
            } else if (element.attributes.first.value == "pref_plan_before") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_procedure_before",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete40_wish") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_jackpot",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete40_optimal") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_optimal",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete40_real") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_real",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete40_minimal") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_minimal",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete40_chaos") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_chaos",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete60_wish") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_jackpot",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete60_optimal") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_optimal",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete60_real") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_real",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete60_minimal") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_minimal",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_complete60_chaos") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_chaos",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth40_wish") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_jackpot",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth40_optimal") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_optimal",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth40_real") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_real",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth40_minimal") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_minimal",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth40_chaos") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_chaos",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth60_wish") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_jackpot",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth60_optimal") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_optimal",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth60_real") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_real",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth60_minimal") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_minimal",
                  element.text);
            } else if (element.attributes.first.value ==
                "pref_goal_tenth60_chaos") {
              prefs.setString(
                  "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_chaos",
                  element.text);
            }
          }
        } catch (_) {
          log("No SharedPrefs. for weapon $i", name: "Migration-Android");
          continue;
        }
      }
    } else if (Platform.isIOS) {
      log("Migrate SharedPrefs", name: "Migration-iOS");

      try {
        NativeSharedPreferences nativePref =
            await NativeSharedPreferences.getInstance();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        log("Migrate User Data", name: "Migration-iOS");
        prefs.setString(
            "data_person_name", nativePref.getString('user_name') ?? "");
        prefs.setString(
            "data_person_age", nativePref.getString('user_age') ?? "");
        prefs.setString(
            "data_person_height", nativePref.getString('user_height') ?? "");
        prefs.setString(
            "data_person_club_1", nativePref.getString('user_club_1') ?? "");
        prefs.setString(
            "data_person_club_2", nativePref.getString('user_club_2') ?? "");
        prefs.setString(
            "data_person_trainer", nativePref.getString('user_trainer') ?? "");
        prefs.setString("data_person_trainer_mail",
            nativePref.getString('user_trainer_mail') ?? "");
        prefs.setString("data_person_squadtrainer",
            nativePref.getString('user_squad_trainer') ?? "");
        prefs.setString("data_person_squadtrainer_mail",
            nativePref.getString('user_squad_trainer_mail') ?? "");
        prefs.setString(
            "data_device", nativePref.getString('device_data') ?? "");

        log("Migrate weapon data", name: "Migration-iOS");
        for (var i = 1; i < 13; i++) {
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_procedure_shot",
              nativePref.getString('procedure_during_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_procedure_before",
              nativePref.getString('procedure_before_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_jackpot",
              nativePref.getString('goals_whole_40_jackpot_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_optimal",
              nativePref.getString('goals_whole_40_optimal_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_real",
              nativePref.getString('goals_whole_40_real_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_minimal",
              nativePref.getString('goals_whole_40_minimal_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_40_chaos",
              nativePref.getString('goals_whole_40_chaos_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_jackpot",
              nativePref.getString('goals_whole_60_jackpot_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_optimal",
              nativePref.getString('goals_whole_60_optimal_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_real",
              nativePref.getString('goals_whole_60_real_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_minimal",
              nativePref.getString('goals_whole_60_minimal_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalWhole_60_chaos",
              nativePref.getString('goals_whole_60_chaos_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_jackpot",
              nativePref.getString('goals_tenth_40_jackpot_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_optimal",
              nativePref.getString('goals_tenth_40_optimal_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_real",
              nativePref.getString('goals_tenth_40_real_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_minimal",
              nativePref.getString('goals_tenth_40_minimal_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_40_chaos",
              nativePref.getString('goals_tenth_40_chaos_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_jackpot",
              nativePref.getString('goals_tenth_60_jackpot_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_optimal",
              nativePref.getString('goals_tenth_60_optimal_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_real",
              nativePref.getString('goals_tenth_60_real_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_minimal",
              nativePref.getString('goals_tenth_60_minimal_$i') ?? "");
          prefs.setString(
              "prefWeapon${i <= 10 ? "0${i - 1}" : i - 1}_goalTenth_60_chaos",
              nativePref.getString('goals_tenth_60_chaos_$i') ?? "");
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
    var objects = PlistParser().parseBytes(list);
    List objectList = objects["\$objects"];
    objectList.removeAt(0);
    objectList.removeAt(0);
    objectList.removeLast();
    return objectList.toString().replaceAll(".0", "");
  }
}
