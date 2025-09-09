import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shoot_report/services/auth_service.dart';

class FirebaseDataService {
  static final StreamController<List<Map<String, dynamic>>> _weaponsController = 
      StreamController<List<Map<String, dynamic>>>.broadcast();
  static final DatabaseReference _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://shoot-report-default-rtdb.europe-west1.firebasedatabase.app')
      .ref();

  // User preferences
  static Future<void> setPreference(String key, String value) async {
    final userId = AuthService.userId;
    if (userId != null) {
      await _database.child('users/$userId/preferences/$key').set(value);
    }
  }

  static Future<String?> getPreference(String key) async {
    final userId = AuthService.userId;
    if (userId != null) {
      final snapshot =
          await _database.child('users/$userId/preferences/$key').get();
      return snapshot.value as String?;
    }
    return null;
  }

  // Global weapons
  static Future<Map<String, dynamic>?> getGlobalWeapons() async {
    final snapshot = await _database.child('global/weapons').get();
    final data = snapshot.value;
    
    if (data == null) return null;
    
    if (data is Map<String, dynamic>) {
      return data;
    } else if (data is Map) {
      return Map<String, dynamic>.from(data);
    } else if (data is List) {
      // Convert list to map with index as key
      final Map<String, dynamic> result = {};
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null) {
          result[i.toString()] = data[i];
        }
      }
      return result;
    }
    
    return null;
  }

  // Global types
  static Future<Map<String, dynamic>?> getGlobalTypes() async {
    final snapshot = await _database.child('global/types').get();
    final data = snapshot.value;
    
    if (data == null) return null;
    
    if (data is Map<String, dynamic>) {
      return data;
    } else if (data is Map) {
      return Map<String, dynamic>.from(data);
    } else if (data is List) {
      // Convert list to map with index as key
      final Map<String, dynamic> result = {};
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null) {
          result[i.toString()] = data[i];
        }
      }
      return result;
    }
    
    return null;
  }

  // User visibility
  static Future<void> setWeaponVisibility(String weaponId, bool visible) async {
    final userId = AuthService.userId;
    if (userId != null) {
      await _database
          .child('users/$userId/visibility/weapons/$weaponId')
          .set(visible);
      
      // Manually refresh the weapons stream
      _refreshWeaponsStream();
    }
  }
  
  static void _refreshWeaponsStream() async {
    try {
      final weapons = await getVisibleWeapons();
      _weaponsController.add(weapons);
    } catch (e) {
      // Silently handle errors
    }
  }

  static Future<bool> getWeaponVisibility(String weaponId) async {
    final userId = AuthService.userId;
    if (userId != null) {
      final snapshot = await _database
          .child('users/$userId/visibility/weapons/$weaponId')
          .get();
      final value = snapshot.value;
      
      if (value == null) return true;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is int) return value != 0;
      
      return true; // Default to visible
    }
    return true;
  }
  
  // Get visible weapons (combines global weapons with user visibility)
  static Future<List<Map<String, dynamic>>> getVisibleWeapons() async {
    try {
      final globalWeapons = await getGlobalWeapons();
      
      if (globalWeapons == null || globalWeapons.isEmpty) {
        return [];
      }
      
      final visibleWeapons = <Map<String, dynamic>>[];
      for (final entry in globalWeapons.entries) {
        final weaponData = entry.value;
        final weaponId = entry.key;
        
        // Convert to proper Map<String, dynamic>
        Map<String, dynamic> weapon;
        if (weaponData is Map<String, dynamic>) {
          weapon = weaponData;
        } else if (weaponData is Map) {
          weapon = Map<String, dynamic>.from(weaponData);
        } else {
          continue;
        }
        
        final isVisible = await getWeaponVisibility(weaponId);
        
        if (isVisible) {
          visibleWeapons.add(weapon);
        }
      }
      
      visibleWeapons.sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
      return visibleWeapons;
    } catch (e) {
      return [];
    }
  }
  
  // Stream for weapon visibility changes
  static Stream<List<Map<String, dynamic>>> getVisibleWeaponsStream() {
    // Initialize stream with current data
    _refreshWeaponsStream();
    
    return _weaponsController.stream;
  }
  


  // User trainings
  static Future<void> saveTraining(Map<String, dynamic> training) async {
    final userId = AuthService.userId;
    if (userId != null) {
      await _database.child('users/$userId/trainings').push().set(training);
    }
  }

  static Future<void> deleteTraining(String trainingKey) async {
    final userId = AuthService.userId;
    if (userId != null) {
      await _database.child('users/$userId/trainings/$trainingKey').remove();
    }
  }

  static Future<void> updateTraining(
      String trainingKey, Map<String, dynamic> training) async {
    final userId = AuthService.userId;
    if (userId != null) {
      await _database
          .child('users/$userId/trainings/$trainingKey')
          .update(training);
    }
  }

  static Future<Map<String, dynamic>?> getUserTrainings() async {
    final userId = AuthService.userId;
    if (userId != null) {
      final snapshot = await _database.child('users/$userId/trainings').get();
      return snapshot.value as Map<String, dynamic>?;
    }
    return null;
  }

  static Stream<Map<String, dynamic>?> getUserTrainingsStream() {
    final userId = AuthService.userId;
    if (userId != null) {
      return _database.child('users/$userId/trainings').onValue.map((event) {
        if (event.snapshot.exists) {
          final data = event.snapshot.value;
          if (data is Map<String, dynamic>) {
            return data;
          } else if (data is Map) {
            return Map<String, dynamic>.from(data);
          }
        }
        return <String, dynamic>{};
      });
    }
    return Stream.value(<String, dynamic>{});
  }

  // User competitions
  static Future<void> saveCompetition(Map<String, dynamic> competition) async {
    final userId = AuthService.userId;
    if (userId != null) {
      await _database
          .child('users/$userId/competitions')
          .push()
          .set(competition);
    }
  }

  static Future<void> deleteCompetition(String competitionKey) async {
    final userId = AuthService.userId;
    if (userId != null) {
      await _database
          .child('users/$userId/competitions/$competitionKey')
          .remove();
    }
  }

  static Future<void> updateCompetition(
      String competitionKey, Map<String, dynamic> competition) async {
    final userId = AuthService.userId;
    if (userId != null) {
      await _database
          .child('users/$userId/competitions/$competitionKey')
          .update(competition);
    }
  }

  static Future<Map<String, dynamic>?> getUserCompetitions() async {
    final userId = AuthService.userId;
    if (userId != null) {
      final snapshot =
          await _database.child('users/$userId/competitions').get();
      return snapshot.value as Map<String, dynamic>?;
    }
    return null;
  }

  static Stream<Map<String, dynamic>?> getUserCompetitionsStream() {
    final userId = AuthService.userId;
    if (userId != null) {
      return _database.child('users/$userId/competitions').onValue.map((event) {
        final data = event.snapshot.value;
        if (data is Map<String, dynamic>) {
          return data;
        } else if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
        return <String, dynamic>{};
      });
    }
    return Stream.value(<String, dynamic>{});
  }
}
