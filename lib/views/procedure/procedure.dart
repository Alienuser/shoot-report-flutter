import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/views/procedure/procedure_preparation.dart';
import 'package:shoot_report/views/procedure/procedure_shot.dart';

class ProcedureWidget extends StatelessWidget {
  final Weapon weapon;

  const ProcedureWidget({
    Key? key,
    required this.weapon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            TabBar(tabs: <Widget>[
              Tab(text: tr("procedure_preparation")),
              Tab(text: tr("procedure_shot")),
            ]),
            Flexible(
              //Add this to give height
              child: TabBarView(children: [
                ProcedurePreparationWidget(weapon: weapon),
                ProcedureShotWidget(weapon: weapon)
              ]),
            ),
          ],
        ));
  }
}
