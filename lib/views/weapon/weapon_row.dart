import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/newWeapon.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/home.dart';

class WeaponListCell extends StatelessWidget {
  final NewWeapon newWeapon;
  final Weapon weapon;
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const WeaponListCell({
    super.key,
    required this.newWeapon,
    required this.weapon,
    required this.weaponDao,
    required this.trainingDao,
    required this.competitionDao,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.legend_toggle_sharp),
      title: Text(tr(weapon.name)),
      trailing: const Icon(Icons.arrow_right_sharp, size: 35),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeWidget(
              weapon: weapon,
              weaponDao: weaponDao,
              trainingDao: trainingDao,
              competitionDao: competitionDao,
            ),
          ),
        );
      },
    );
  }
}
