import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/home.dart';

class WeaponListCell extends StatelessWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const WeaponListCell(
      {Key? key,
      required this.weapon,
      required this.weaponDao,
      required this.trainingDao,
      required this.competitionDao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${weapon.hashCode}'),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        weapon.show = false;
        weaponDao.updateWeapon(weapon);

        final scaffoldMessengerState = ScaffoldMessenger.of(context);
        scaffoldMessengerState.hideCurrentSnackBar();
        scaffoldMessengerState.showSnackBar(
          SnackBar(
              content: Text(tr("weapon_deleted", args: [tr(weapon.name)]))),
        );
      },
      child: ListTile(
        leading: const Icon(Icons.legend_toggle_sharp),
        title: Text(tr(weapon.name)),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeWidget(
                  weapon: weapon,
                  weaponDao: weaponDao,
                  trainingDao: trainingDao,
                  competitionDao: competitionDao),
            ),
          );
        },
      ),
    );
  }
}
