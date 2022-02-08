import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shoot_report/main_app.dart';
import 'package:version_migration/version_migration.dart';
import 'utilities/database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final database = await $FloorFlutterDatabase
      .databaseBuilder('flutter_database.db')
      .build();
  final weaponDao = database.weaponDao;
  final trainingDao = database.trainingDao;
  final competitionDao = database.competitionDao;

  FlutterNativeSplash.removeAfter(initialization);

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

void initialization(BuildContext context) async {
  // TODO Delete after  debugging
  VersionMigration.reset();

  VersionMigration.migrateToVersion("1.5.0", () {
    //AppMigration.doDatabaseMigration();
    //AppMigration.doSharedPrefMigration();
    // TODO Adding weapons to new database
  });

  await Future.delayed(const Duration(seconds: 2));
}
