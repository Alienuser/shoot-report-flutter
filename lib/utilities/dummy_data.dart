import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';

class DummyData extends StatelessWidget {
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const DummyData(
      {Key? key,
      required this.weaponDao,
      required this.trainingDao,
      required this.competitionDao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlinedButton(
              child: const Text('Set Trainings-Data'),
              onPressed: () async {
                await _setTestingData();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setTestingData() async {
    for (var i = 0; i < 5; i++) {
      _persistMessageWeapon("weapon_$i", "prefWeapon$i");
      _persistMessageTraining("Training $i", 1);
      _persistMessageCompetition("Competition $i", 1);
    }
  }

  Future<void> _persistMessageWeapon(String name, String prefFile) async {
    final task = Weapon(null, name, 0, prefFile, true);
    await weaponDao.insertWeapon(task);
  }

  Future<void> _persistMessageTraining(String name, int weaponId) async {
    Random random = Random();
    final task = Training(null, DateTime.now(), "", random.nextInt(4),
        "Ehningen", "Einrichten", 10, [5], "Ein Kommentar dazu", 1);
    await trainingDao.insertTraining(task);
  }

  Future<void> _persistMessageCompetition(String name, int weaponId) async {
    final competition = Competition(null, DateTime.now(), "", "Ehningen",
        "Zielen", 5, "1, 2, 3, 4, 5", "Ein Kommentar dazu", 1);
    await competitionDao.insertCompetition(competition);
  }
}
