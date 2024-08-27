import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/competition/competition_list.dart';
import 'package:shoot_report/views/competition/competition_statistics.dart';

class CompetitionWidget extends StatelessWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;
  final CompetitionDao competitionDao;

  const CompetitionWidget(
      {super.key,
      required this.weapon,
      required this.weaponDao,
      required this.competitionDao});

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Material(
              color: (mode.brightness == Brightness.light)
                  ? const Color(AppTheme.backgroundLight)
                  : const Color(AppTheme.backgroundDark),
              child: TabBar(tabs: <Widget>[
                Tab(text: tr("competition_menu_competition").toUpperCase()),
                Tab(text: tr("competition_menu_statistic").toUpperCase()),
              ]),
            ),
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
