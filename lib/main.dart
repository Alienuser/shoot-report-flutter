import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shoot_report/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shoot_report/main_app.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/services/migration_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Flutter initialization
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Splash initialization
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Language initialization
  await EasyLocalization.ensureInitialized();

  // General initialization
  _initialization();

  // Run the app
  runApp(EasyLocalization(
      supportedLocales: const [Locale("en"), Locale("de")],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ShootReport()));
}

void _initialization() async {
  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase configuration
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Perform Firebase migration
  await MigrationService.performMigration();

  // Log App opened
  FirebaseLog().logAppStart();

  // Wait some time to show splash
  await Future.delayed(const Duration(seconds: 2));

  // Dismiss the splash
  FlutterNativeSplash.remove();
}
