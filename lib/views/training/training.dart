import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/training/training_list.dart';
import 'package:shoot_report/views/training/training_statistics.dart';

class TrainingWidget extends StatelessWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;

  const TrainingWidget(
      {Key? key,
      required this.weapon,
      required this.weaponDao,
      required this.trainingDao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            TabBar(tabs: <Widget>[
              Tab(text: tr("training_menu_training")),
              Tab(text: tr("training_menu_statistic")),
            ]),
            Flexible(
              //Add this to give height
              child: TabBarView(children: [
                TrainingListWidget(
                    weapon: weapon,
                    weaponDao: weaponDao,
                    trainingDao: trainingDao),
                TrainingStatisticWidget(
                    weapon: weapon, trainingDao: trainingDao)
              ]),
            ),
          ],
        ));
  }
}
