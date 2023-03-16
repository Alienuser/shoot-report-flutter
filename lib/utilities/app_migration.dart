import 'dart:developer';
import 'package:shoot_report/utilities/database.dart';

class AppMigration {
  ///
  /// Migration functions
  ///

  static void migrate_1_6_0(FlutterDatabase database) {
    // Migrate the database
    addEmptyShots(database);
    replaceNullValues(database);
  }

  ///
  /// Helper functions
  ///

  static void addEmptyShots(FlutterDatabase database) {
    log("Adding shots start.");
    database.trainingDao.findAllTrainings().forEach((elements) {
      for (var element in elements) {
        if (element.shots.length < (element.shotCount / 10)) {
          for (int i = 0;
              i <= (element.shotCount / 10) - element.shots.length;
              i++) {
            element.shots.add(-1);
          }
          database.trainingDao.updateTraining(element);
        }
      }

      database.competitionDao.findAllCompetitions().forEach((elements) {
        for (var element in elements) {
          if (element.shots.length < (element.shotCount / 10)) {
            for (int i = 0;
                i <= (element.shotCount / 10) - element.shots.length;
                i++) {
              element.shots.add(-1);
            }
            database.competitionDao.updateCompetition(element);
          }
        }
      });
    });
    log("Adding shots finished.");
  }

  static void replaceNullValues(FlutterDatabase database) {
    log("Replacing null values start.");

    database.trainingDao.findAllTrainings().forEach((elements) {
      for (var element in elements) {
        if (element.shots.contains(null)) {
          element.shots[element.shots.indexOf(null)] = -1;
          database.trainingDao.updateTraining(element);
        }
      }
    });

    database.competitionDao.findAllCompetitions().forEach((elements) {
      for (var element in elements) {
        if (element.shots.contains(null)) {
          element.shots[element.shots.indexOf(null)] = -1;
          database.competitionDao.updateCompetition(element);
        }
      }
    });

    log("Replacing null values finished.");
  }
}
