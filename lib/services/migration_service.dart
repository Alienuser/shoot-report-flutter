import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/services/auth_service.dart';
import 'package:shoot_report/services/firebase_data_service.dart';
import 'package:sqflite/sqflite.dart';

class MigrationService {
  static const String _migrationKey = 'firebase_migration_completed';

  static Future<bool> isMigrationCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_migrationKey) ?? false;
  }

  static Future<void> performMigration() async {
    if (await isMigrationCompleted()) return;

    await AuthService.signInAnonymously();

    // Try to migrate from SQLite if database exists
    await _migrateFromSQLite();

    // Migrate SharedPreferences
    await _migrateSharedPreferences();

    // Mark migration as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_migrationKey, true);
  }

  static Future<void> _migrateFromSQLite() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'flutter_shoot_report.db');
      
      if (!await File(path).exists()) {
        return;
      }

      final database = await openDatabase(path);
      final userId = AuthService.userId;
      if (userId == null) return;

      final DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$userId');

      try {
        final trainings = await database.query('Training');
        for (final training in trainings) {
          await userRef.child('trainings').push().set({
            'date': training['date'],
            'image': training['image'] ?? '',
            'indicator': training['indicator'] ?? 2,
            'place': training['place'] ?? '',
            'kind': training['kind'] ?? '',
            'shotCount': training['shotCount'] ?? 0,
            'shots': training['shots'] ?? '[]',
            'comment': training['comment'] ?? '',
            'weaponId': training['weapon_id'],
          });
        }
      } catch (e) {}

      try {
        final competitions = await database.query('Competition');
        for (final competition in competitions) {
          await userRef.child('competitions').push().set({
            'date': competition['date'],
            'image': competition['image'] ?? '',
            'place': competition['place'] ?? '',
            'kind': competition['kind'] ?? '',
            'shotCount': competition['shotCount'] ?? 0,
            'shots': competition['shots'] ?? '[]',
            'comment': competition['comment'] ?? '',
            'weaponId': competition['weapon_id'],
          });
        }
      } catch (e) {}

      try {
        final weapons = await database.query('Weapon');
        for (final weapon in weapons) {
          await userRef.child('visibility/weapons/${weapon['id']}').set(weapon['show'] == 1);
        }
      } catch (e) {}

      await database.close();
    } catch (e) {}
  }

  static Future<void> _migrateSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (final key in keys) {
      if (key.contains('_goal') || key.contains('_pref')) {
        final value = prefs.getString(key);
        if (value != null) {
          await FirebaseDataService.setPreference(key, value);
        }
      }
    }
  }
}
