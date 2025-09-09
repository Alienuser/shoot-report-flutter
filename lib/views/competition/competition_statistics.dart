import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/firebase_data_service.dart';
import 'package:shoot_report/utilities/chart_data.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/widgets/statistic.dart';

class CompetitionStatisticWidget extends StatefulWidget {
  final Weapon weapon;

  const CompetitionStatisticWidget({super.key, required this.weapon});

  @override
  State<CompetitionStatisticWidget> createState() =>
      _CompetitionStatisticWidgetState();
}

class _CompetitionStatisticWidgetState
    extends State<CompetitionStatisticWidget> {
  @override
  void initState() {
    super.initState();
    FirebaseLog()
        .logScreenView("competition_statistics.dart", "competition_statistic");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<Map<String, dynamic>?>(
            stream: FirebaseDataService.getUserCompetitionsStream(),
            builder: (_, snapshot) {
              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
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
                      Text(tr("competition_statistic_data_no"),
                          textAlign: TextAlign.center)
                    ]));
              }

              List<ChartData> dataWhole = <ChartData>[];
              List<ChartData> dataTenth = <ChartData>[];
              final competitionsData = snapshot.data!;
              final competitions = competitionsData.entries
                  .where((entry) {
                    final data = Map<String, dynamic>.from(entry.value as Map);
                    return data['weaponId'] == widget.weapon.id!;
                  })
                  .map((entry) {
                    final data = Map<String, dynamic>.from(entry.value as Map);
                    return Competition(
                      null,
                      DateTime.fromMillisecondsSinceEpoch(data['date']),
                      data['image'] ?? '',
                      data['place'] ?? '',
                      data['kind'] ?? '',
                      data['shotCount'] ?? 0,
                      data['shots'] ?? [],
                      data['comment'] ?? '',
                      data['weaponId'] ?? widget.weapon.id!,
                    );
                  }).toList();
              
              for (var competition in competitions) {
                if (competition.shots.isNotEmpty) {
                  var rings = competition.shots.reduce((value, next) =>
                      (value != null && next != null)
                          ? value + next
                          : value + 0);
                  bool isTenth =
                      competition.shots.any((element) => element is double);

                  if (!isTenth && dataWhole.length < 100) {
                    dataWhole.add(ChartData(
                        x: DateFormat.yMMMd().format(competition.date),
                        y: rings));
                  } else if (isTenth && dataTenth.length < 100) {
                    dataTenth.add(ChartData(
                        x: DateFormat.yMMMd().format(competition.date),
                        y: rings));
                  }
                }
              }

              return Column(children: [
                Expanded(
                    child: StatisticWidget(
                        title: tr("competition_statistic_whole"),
                        dataSource: dataWhole.reversed.toList(),
                        color: const Color(AppTheme.chartWholeColor))),
                Expanded(
                    child: StatisticWidget(
                        title: tr("competition_statistic_tenth"),
                        dataSource: dataTenth.reversed.toList(),
                        color: const Color(AppTheme.chartTenthColor)))
              ]);
            }));
  }
}
