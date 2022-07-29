import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shoot_report/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
  // Flutter initialization
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Splash initialization
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Language initialization
  await EasyLocalization.ensureInitialized();
  // Database initialization
  database = await $FloorFlutterDatabase
      .databaseBuilder('flutter_shoot_report.db')
      .build();
  WeaponDao weaponDao = database.weaponDao;
  TrainingDao trainingDao = database.trainingDao;
  CompetitionDao competitionDao = database.competitionDao;
  // General initialization
  _initialization();

  // Run the app
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

void _initialization() async {
  // Reset the migration for debug
  //VersionMigration.reset();

  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Migrate to version 1.5.0
  VersionMigration.migrateToVersion("1.5.0", () {
    // Run migration
    AppMigration.migrate_1_5_0(database);
    // Log migration
    FirebaseLog().logEvent("migration_1_5_0");
  });

  // Migrate to version 1.5.2
  VersionMigration.migrateToVersion("1.5.2", () {
    // Run migration
    AppMigration.migrate_1_5_2(database);
    // Log migration
    FirebaseLog().logEvent("migration_1_5_2");
  });

  // Log App opened
  FirebaseLog().logAppStart();

  // Wait some time to show splash
  await Future.delayed(const Duration(seconds: 2));

  // Dismiss the splash
  FlutterNativeSplash.remove();
}
