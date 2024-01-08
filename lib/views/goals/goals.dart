import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/goals/goals_tenth.dart';
import 'package:shoot_report/views/goals/goals_whole.dart';

class GoalsWidget extends StatelessWidget {
  final Weapon weapon;
  const GoalsWidget({
    super.key,
    required this.weapon,
  });

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
                Tab(text: tr("goals_whole").toUpperCase()),
                Tab(text: tr("goals_tenth").toUpperCase())
              ]),
            ),
            Flexible(
              child: TabBarView(children: [
                GoalsWholeWidget(weapon: weapon),
                GoalsTenthWidget(weapon: weapon)
              ]),
            ),
          ],
        ));
  }
}
