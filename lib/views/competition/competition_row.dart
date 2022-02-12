import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/views/competition/competition_edit.dart';

class CompetitionListRow extends StatelessWidget {
  final Weapon weapon;
  final CompetitionDao competitionDao;
  final Competition competition;

  const CompetitionListRow({
    Key? key,
    required this.weapon,
    required this.competitionDao,
    required this.competition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${competition.hashCode}'),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        competitionDao.deleteCompetition(competition);

        final scaffoldMessengerState = ScaffoldMessenger.of(context);
        scaffoldMessengerState.hideCurrentSnackBar();
        scaffoldMessengerState.showSnackBar(
          SnackBar(content: Text(tr("competition_deleted"))),
        );
      },
      child: ListTile(
        leading: getCompetitionPoints(competition),
        title: Text(competition.kind),
        subtitle: Text(
            "${DateFormat.yMd().format(competition.date)}, in ${competition.place}"),
        onTap: () {
          showBarModalBottomSheet(
            context: context,
            expand: true,
            builder: (context) => CompetitionEditWidget(
                weapon: weapon,
                competitionDao: competitionDao,
                competition: competition),
          );
        },
      ),
    );
  }

  Text getCompetitionPoints(Competition competition) {
    if (competition.shots.isNotEmpty) {
      num shots =
          competition.shots.fold(0, (previous, current) => previous + current);
      return Text(shots.toString());
    } else {
      return const Text("0");
    }
  }
}
