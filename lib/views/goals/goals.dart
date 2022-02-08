import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/goals/goals_tenth.dart';
import 'package:shoot_report/views/goals/goals_whole.dart';

class GoalsWidget extends StatelessWidget {
  final Weapon weapon;
  const GoalsWidget({
    Key? key,
    required this.weapon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            TabBar(
                indicatorColor: const Color(AppTheme.accentColor),
                labelColor: Colors.black,
                tabs: <Widget>[
                  Tab(text: tr("goals_whole")),
                  Tab(text: tr("goals_tenth"))
                ]),
            Flexible(
              //Add this to give height
              child: TabBarView(children: [
                GoalsWholeWidget(weapon: weapon),
                GoalsTenthWidget(weapon: weapon)
              ]),
            ),
          ],
        ));
  }
}
