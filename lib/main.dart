import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shoot_report/main_app.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/app_migration.dart';
import 'package:version_migration/version_migration.dart';
import 'utilities/database.dart';
import 'package:flutter/material.dart';

late FlutterDatabase database;
late WeaponDao weaponDao;
late TrainingDao trainingDao;
late CompetitionDao competitionDao;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Database initialization
  database = await $FloorFlutterDatabase
      .databaseBuilder('flutter_shoot_report.db')
      .build();
  weaponDao = database.weaponDao;
  trainingDao = database.trainingDao;
  competitionDao = database.competitionDao;

  FlutterNativeSplash.removeAfter(_initialization);

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale("en"), Locale("de")],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: ShootReport(
            weaponDao: weaponDao,
            trainingDao: trainingDao,
            competitionDao: competitionDao)),
  );
}

void _initialization(BuildContext context) async {
  //VersionMigration.reset();

  VersionMigration.migrateToVersion("1.5.0", () async {
    AppMigration.doDatabaseMigration(weaponDao);
    //AppMigration.doSharedPrefMigration();
  });

  await Future.delayed(const Duration(seconds: 2));
}
