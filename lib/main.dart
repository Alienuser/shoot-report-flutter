import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shoot_report/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shoot_report/main_app.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/type_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/app_migration.dart';
import 'package:shoot_report/utilities/database.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
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
  TypeDao typeDao = database.typeDao;
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
          typeDao: typeDao,
          weaponDao: weaponDao,
          trainingDao: trainingDao,
          competitionDao: competitionDao,
        )),
  );
}

void _initialization() async {
  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase configuration
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Check if we have to load default weapons
  await AppMigration.loadDefaultWeapons(database.weaponDao);

  // Check if we have to load default types
  await AppMigration.loadDefaultTypes(database.typeDao);

  // Log App opened
  FirebaseLog().logAppStart();

  // Wait some time to show splash
  await Future.delayed(const Duration(seconds: 2));

  // Dismiss the splash
  FlutterNativeSplash.remove();
}
