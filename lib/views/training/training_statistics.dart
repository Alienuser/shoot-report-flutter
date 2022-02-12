import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrainingStatisticWidget extends StatefulWidget {
  final Weapon weapon;
  final TrainingDao trainingDao;

  const TrainingStatisticWidget({
    Key? key,
    required this.weapon,
    required this.trainingDao,
  }) : super(key: key);

  @override
  State<TrainingStatisticWidget> createState() =>
      _TrainingStatisticWidgetState();
}

class _TrainingStatisticWidgetState extends State<TrainingStatisticWidget> {
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
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Icon(
                  Icons.insights,
                  color: Color(AppTheme.primaryColor),
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
            var rings = training.shots.reduce((value, next) => value + next);
            var average = rings / training.shotCount;
            bool isWhole = training.shots.any((element) => element is int);

            if (isWhole && dataWhole.length < 10) {
              dataWhole.add(ChartData(
                  x: DateFormat.MMMd().format(training.date), y: average));
            } else if (!isWhole && dataTenth.length < 10) {
              dataTenth.add(ChartData(
                  x: DateFormat.MMMd().format(training.date), y: average));
            }
          }
        }

        return Column(children: [
          Expanded(
              child: _getChart(
                  tr("training_statistic_whole"),
                  dataWhole.reversed.toList(),
                  const Color(AppTheme.chartWholeColor))),
          Expanded(
              child: _getChart(
                  tr("training_statistic_tenth"),
                  dataTenth.reversed.toList(),
                  const Color(AppTheme.chartTenthColor))),
        ]);
      },
    ));
  }

  SfCartesianChart _getChart(
      String title, List<ChartData> dataSource, Color color) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: title),
      tooltipBehavior: TooltipBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          format: "\u00D8: point.y",
          shouldAlwaysShow: true),
      onTooltipRender: (TooltipArgs args) {
        args.text = 'Customized Text';
      },
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          title: AxisTitle(text: tr("training_statistic_rings"))),
      series: [
        SplineSeries<ChartData, String>(
            dataSource: dataSource,
            color: color,
            animationDuration: 1500,
            animationDelay: 0,
            xValueMapper: (ChartData sales, _) => sales.x,
            yValueMapper: (ChartData sales, _) => sales.y,
            name: '\u00D8',
            markerSettings: MarkerSettings(isVisible: true, color: color)),
      ],
    );
  }
}

class ChartData {
  ChartData({required this.x, required this.y});

  final String x;
  final num y;
}
