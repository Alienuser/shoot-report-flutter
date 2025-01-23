import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticWidget extends StatefulWidget {
  final String title;
  final List<ChartData> dataSource;
  final Color color;

  const StatisticWidget(
      {super.key,
      required this.title,
      required this.dataSource,
      required this.color});

  @override
  State<StatisticWidget> createState() => _StatisticWidgetState();
}

class _StatisticWidgetState extends State<StatisticWidget> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: widget.title),
        tooltipBehavior: TooltipBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            format: "${tr("training_statistics_result")}: point.y",
            shouldAlwaysShow: true),
        onTooltipRender: (TooltipArgs args) {
          args.header = args.dataPoints![args.pointIndex!.toInt()].x;
        },
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          interval: 1,
          labelRotation: 30,
          autoScrollingDelta: 10,
        ),
        primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          title: AxisTitle(text: tr("training_statistic_rings")),
        ),
        zoomPanBehavior:
            ZoomPanBehavior(enablePanning: true, zoomMode: ZoomMode.x),
        series: [
          SplineSeries<ChartData, String>(
            dataSource: widget.dataSource,
            color: widget.color,
            animationDuration: 500,
            animationDelay: 0,
            splineType: SplineType.natural,
            xValueMapper: (ChartData point, _) => point.x,
            yValueMapper: (ChartData point, _) => point.y,
            name: tr("training_statistics_result"),
            markerSettings:
                MarkerSettings(isVisible: true, color: widget.color),
          )
        ]);
  }
}
