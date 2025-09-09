import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/services/auth_service.dart';

class MigrationService {
  static const String _migrationKey = 'firebase_migration_completed';

  static Future<bool> isMigrationCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_migrationKey) ?? false;
  }

  static Future<void> performMigration() async {
    if (await isMigrationCompleted()) return;

    await AuthService.signInAnonymously();

    // Migration is disabled since SQLite database is no longer available
    // Mark migration as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_migrationKey, true);
  }
}
