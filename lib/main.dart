import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shoot_report/firebase_options.dart';
import 'package:shoot_report/main_app.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/app_migration.dart';
import 'package:shoot_report/utilities/database.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:version_migration/version_migration.dart';
import 'package:flutter/material.dart';

late FlutterDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Splash initialization
  FlutterNativeSplash.removeAfter(_initialization);
  // Language initialization
  await EasyLocalization.ensureInitialized();
  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Database initialization
  database = await $FloorFlutterDatabase
      .databaseBuilder('flutter_shoot_report.db')
      .build();
  WeaponDao weaponDao = database.weaponDao;
  TrainingDao trainingDao = database.trainingDao;
  CompetitionDao competitionDao = database.competitionDao;

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale("en"), Locale("de")],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: ShootReport(
          weaponDao: weaponDao,
          trainingDao: trainingDao,
          competitionDao: competitionDao,
        )),
  );
}

void _initialization(BuildContext context) async {
  VersionMigration.reset();

  // Migrate to version 1.5.0
  VersionMigration.migrateToVersion("1.5.0", () async {
    // Migrate the database
    AppMigration.doDatabaseMigration(database);
    // Migrate the shared preferences
    AppMigration.doSharedPrefMigration();
    // Log Migration to 1.5.0
    FirebaseLog().logEvent("migration_1_5_0");
  });

  // Log App opended
  FirebaseLog().logAppStart();

  // Wait some time to show splashscreen
  await Future.delayed(const Duration(seconds: 2));
}
