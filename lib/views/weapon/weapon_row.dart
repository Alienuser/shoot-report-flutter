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
    return ListTile(
      leading: const Icon(Icons.legend_toggle_sharp),
      title: Text(tr(weapon.name)),
      trailing: IconButton(
          onPressed: () {
            _deleteWeapon(context);
          },
          icon: const Icon(Icons.delete)),
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
    );
  }

  void _deleteWeapon(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(tr("weapon_alert_title")),
            content: Text(tr("weapon_alert_message")),
            actions: [
              TextButton(
                  onPressed: () {
                    weapon.show = false;
                    weaponDao.updateWeapon(weapon);

                    final scaffoldMessengerState =
                        ScaffoldMessenger.of(context);
                    scaffoldMessengerState.hideCurrentSnackBar();
                    scaffoldMessengerState.showSnackBar(
                      SnackBar(
                          content: Text(
                              tr("weapon_deleted", args: [tr(weapon.name)])),
                          behavior: SnackBarBehavior.floating),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(tr("general_yes"))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(tr("general_no")))
            ],
          );
        });
  }
}
