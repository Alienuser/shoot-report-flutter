import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CompetitionStatisticWidget extends StatelessWidget {
  final Weapon weapon;

  const CompetitionStatisticWidget({
    Key? key,
    required this.weapon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: SfCartesianChart()));
  }
}
