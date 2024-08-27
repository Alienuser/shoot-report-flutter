import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/procedure/procedure_preparation.dart';
import 'package:shoot_report/views/procedure/procedure_shot.dart';

class ProcedureWidget extends StatelessWidget {
  final Weapon weapon;

  const ProcedureWidget({
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
                Tab(text: tr("procedure_preparation").toUpperCase()),
                Tab(text: tr("procedure_shot").toUpperCase()),
              ]),
            ),
            Flexible(
              child: TabBarView(children: [
                ProcedurePreparationWidget(weapon: weapon),
                ProcedureShotWidget(weapon: weapon)
              ]),
            ),
          ],
        ));
  }
}
