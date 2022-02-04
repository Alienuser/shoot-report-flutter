import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/weapon/weapon_row.dart';

class WeaponListView extends StatelessWidget {
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const WeaponListView(
      {Key? key,
      required this.weaponDao,
      required this.trainingDao,
      required this.competitionDao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Weapon>>(
        stream: weaponDao.findAllWeapons(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Daten werden geladen...");
          }
          if (snapshot.data.toString() == "[]") {
            return const Text('Keine Daten da...');
          }

          final weapons = snapshot.requireData;

          return ListView.separated(
            itemCount: weapons.length,
            itemBuilder: (context, index) {
              return WeaponListCell(
                  weapon: weapons[index],
                  weaponDao: weaponDao,
                  trainingDao: trainingDao,
                  competitionDao: competitionDao);
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 5);
            },
          );
        },
      ),
    );
  }
}
