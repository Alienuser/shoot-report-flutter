import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'competition_list.dart';
import 'competition_statistics.dart';

class CompetitionWidget extends StatelessWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;
  final CompetitionDao competitionDao;

  const CompetitionWidget(
      {Key? key,
      required this.weapon,
      required this.weaponDao,
      required this.competitionDao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            TabBar(tabs: <Widget>[
              Tab(text: tr("competition_menu_competition")),
              Tab(text: tr("competition_menu_statistic")),
            ]),
            Flexible(
              child: TabBarView(children: [
                CompetitionListWidget(
                  weapon: weapon,
                  weaponDao: weaponDao,
                  competitionDao: competitionDao,
                ),
                CompetitionStatisticWidget(
                  weapon: weapon,
                  competitionDao: competitionDao,
                )
              ]),
            ),
          ],
        ));
  }
}
