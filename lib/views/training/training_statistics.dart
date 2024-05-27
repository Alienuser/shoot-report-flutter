import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/utilities/chart_data.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/widgets/statistic.dart';

class TrainingStatisticWidget extends StatefulWidget {
  final Weapon weapon;
  final TrainingDao trainingDao;

  const TrainingStatisticWidget({
    super.key,
    required this.weapon,
    required this.trainingDao,
  });

  @override
  State<TrainingStatisticWidget> createState() =>
      _TrainingStatisticWidgetState();
}

class _TrainingStatisticWidgetState extends State<TrainingStatisticWidget> {
  @override
  void initState() {
    super.initState();
    FirebaseLog()
        .logScreenView("training_statistics.dart", "training_statistic");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<Training>>(
      stream: widget.trainingDao.findAllTrainingsForWeapon(widget.weapon.id!),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        if (snapshot.data.toString() == "[]") {
          final ThemeData mode = Theme.of(context);
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(
                  Icons.insights,
                  color: (mode.brightness == Brightness.light)
                      ? const Color(AppTheme.primaryColor)
                      : const Color(AppTheme.backgroundLight),
                  size: 120,
                ),
                Text(
                  tr("training_statistic_data_no"),
                  textAlign: TextAlign.center,
                )
              ]));
        }

        List<ChartData> dataWhole = <ChartData>[];
        List<ChartData> dataTenth = <ChartData>[];
        final trainings = snapshot.requireData;
        for (var training in trainings) {
          if (training.shots.isNotEmpty) {
            var rings = training.shots.reduce((value, next) =>
                (value != null && next != null) ? value + next : value + 0);
            var average = rings / training.shotCount;
            bool isTenth = training.shots.any((element) => element is double);

            if (!isTenth && dataWhole.length < 100) {
              dataWhole.add(ChartData(
                  x: DateFormat.yMMMd().format(training.date), y: average));
            } else if (isTenth && dataTenth.length < 100) {
              dataTenth.add(ChartData(
                  x: DateFormat.yMMMd().format(training.date), y: average));
            }
          }
        }

        return Column(children: [
          Expanded(
              child: StatisticWidget(
                  title: tr("training_statistic_whole"),
                  dataSource: dataWhole.reversed.toList(),
                  color: const Color(AppTheme.chartWholeColor))),
          Expanded(
              child: StatisticWidget(
                  title: tr("training_statistic_tenth"),
                  dataSource: dataTenth.reversed.toList(),
                  color: const Color(AppTheme.chartTenthColor))),
        ]);
      },
    ));
  }
}
