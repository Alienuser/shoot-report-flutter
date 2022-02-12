import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CompetitionStatisticWidget extends StatefulWidget {
  final Weapon weapon;
  final CompetitionDao competitionDao;

  const CompetitionStatisticWidget({
    Key? key,
    required this.weapon,
    required this.competitionDao,
  }) : super(key: key);

  @override
  State<CompetitionStatisticWidget> createState() =>
      _CompetitionStatisticWidgetState();
}

class _CompetitionStatisticWidgetState
    extends State<CompetitionStatisticWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<Competition>>(
      stream:
          widget.competitionDao.findAllCompetitionForWeapon(widget.weapon.id!),
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
                  tr("competition_statistic_data_no"),
                  textAlign: TextAlign.center,
                )
              ]));
        }

        List<ChartData> dataWhole = <ChartData>[];
        List<ChartData> dataTenth = <ChartData>[];
        final competitions = snapshot.requireData;
        for (var competition in competitions) {
          if (competition.shots.isNotEmpty) {
            var rings = competition.shots.reduce((value, next) => value + next);
            bool isTenth =
                competition.shots.any((element) => element is double);

            if (!isTenth && dataWhole.length < 10) {
              dataWhole.add(ChartData(
                  x: DateFormat.MMMd().format(competition.date), y: rings));
            } else if (isTenth && dataTenth.length < 10) {
              dataTenth.add(ChartData(
                  x: DateFormat.MMMd().format(competition.date), y: rings));
            }
          }
        }

        return Column(children: [
          Expanded(
              child: _getChart(
                  tr("competition_statistic_whole"),
                  dataWhole.reversed.toList(),
                  const Color(AppTheme.chartWholeColor))),
          Expanded(
              child: _getChart(
                  tr("competition_statistic_tenth"),
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
        args.header = args.dataPoints![args.pointIndex!.toInt()].x;
      },
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          title: AxisTitle(text: tr("competition_statistic_rings"))),
      series: [
        SplineSeries<ChartData, String>(
            dataSource: dataSource,
            color: color,
            animationDuration: 500,
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
