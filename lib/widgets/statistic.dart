import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticWidget extends StatefulWidget {
  final String title;
  final List<ChartData> dataSource;
  final Color color;

  const StatisticWidget(
      {Key? key,
      required this.title,
      required this.dataSource,
      required this.color})
      : super(key: key);

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
          title: AxisTitle(text: tr("training_statistic_rings"))),
      series: [
        SplineSeries<ChartData, String>(
            dataSource: widget.dataSource,
            color: widget.color,
            animationDuration: 500,
            animationDelay: 0,
            xValueMapper: (ChartData sales, _) => sales.x,
            yValueMapper: (ChartData sales, _) => sales.y,
            name: '\u00D8',
            markerSettings:
                MarkerSettings(isVisible: true, color: widget.color)),
      ],
    );
  }
}