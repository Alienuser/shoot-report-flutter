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
          return const Text("Keine Daten da...");
        }
        if (snapshot.data.toString() == "[]") {
          return const Text('Keine Daten da...');
        }

        List<ChartData> dataWhole = <ChartData>[];
        List<ChartData> dataTenth = <ChartData>[];
        final trainings = snapshot.requireData;
        for (var training in trainings) {
          dataWhole.add(ChartData(x: training.id.toString(), y: training.id));
          dataTenth.add(ChartData(x: training.id.toString(), y: training.id));
        }

        return Column(children: [
          Expanded(
              child: _getChart("Ganze Ringe", dataWhole,
                  const Color(CompanyColors.chartWholeColor))),
          Expanded(
              child: _getChart("Zehntel Ringe", dataTenth,
                  const Color(CompanyColors.chartTenthColor))),
        ]);
      },
    ));
  }

  SfCartesianChart _getChart(
      String title, List<ChartData> dataSource, Color color) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: title),
      trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          markerSettings: const TrackballMarkerSettings(
              markerVisibility: TrackballVisibilityMode.visible),
          tooltipSettings: const InteractiveTooltip(format: '\u00D8: point.y')),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: [
        SplineSeries<ChartData, String>(
            dataSource: dataSource,
            color: color,
            xValueMapper: (ChartData sales, _) => sales.x,
            yValueMapper: (ChartData sales, _) => sales.y,
            name: '\u00D8',
            markerSettings: const MarkerSettings(isVisible: true)),
      ],
    );
  }
}

class ChartData {
  ChartData({required this.x, required this.y});

  final String x;
  final num? y;
}
