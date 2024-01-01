import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/views/competition/competition_edit.dart';

class CompetitionListRow extends StatefulWidget {
  final Weapon weapon;
  final CompetitionDao competitionDao;
  final Competition competition;

  const CompetitionListRow({
    super.key,
    required this.weapon,
    required this.competitionDao,
    required this.competition,
  });

  @override
  State<CompetitionListRow> createState() => _CompetitionListRowState();
}

class _CompetitionListRowState extends State<CompetitionListRow> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 20,
      leading: SizedBox(
          width: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _getCompetitionPoints(widget.competition),
            ],
          )),
      title: Text(widget.competition.kind),
      subtitle: Text(
          "${DateFormat.yMMMd().format(widget.competition.date)}, in ${widget.competition.place}"),
      trailing: IconButton(
          onPressed: () {
            _deleteCompetition();
          },
          icon: const Icon(Icons.delete)),
      onTap: () {
        showBarModalBottomSheet(
          context: context,
          expand: true,
          builder: (context) => CompetitionEditWidget(
              weapon: widget.weapon,
              competitionDao: widget.competitionDao,
              competition: widget.competition),
        );
      },
    );
  }

  void _deleteCompetition() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog.adaptive(
            title: Text(tr("competition_alert_title")),
            content: Text(tr("competition_alert_message")),
            actions: [
              TextButton(
                  onPressed: () {
                    widget.competitionDao.deleteCompetition(widget.competition);

                    final scaffoldMessengerState =
                        ScaffoldMessenger.of(context);
                    scaffoldMessengerState.hideCurrentSnackBar();
                    scaffoldMessengerState.showSnackBar(
                      SnackBar(
                          content: Text(tr("competition_deleted")),
                          behavior: SnackBarBehavior.floating),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(tr("general_yes"))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(tr("general_no")))
            ],
          );
        });
  }

  Text _getCompetitionPoints(Competition competition) {
    if (competition.shots.isNotEmpty) {
      if (competition.shots.any((element) => element is double)) {
        num shots = competition.shots.reduce((value, next) =>
            (value != null && next != null) ? value + next : value + 0);
        return Text(shots.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold));
      } else {
        num shots = competition.shots.reduce((value, next) =>
            (value != null && next != null) ? value + next : value + 0);
        return Text(shots.toStringAsFixed(0),
            style: const TextStyle(fontWeight: FontWeight.bold));
      }
    } else {
      return const Text("0", style: TextStyle(fontWeight: FontWeight.bold));
    }
  }
}
