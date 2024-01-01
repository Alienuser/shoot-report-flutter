import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/utilities/indicator_to_image.dart';
import 'package:shoot_report/views/training/training_edit.dart';

class TrainingListRow extends StatefulWidget {
  final Weapon weapon;
  final TrainingDao trainingDao;
  final Training training;

  const TrainingListRow({
    super.key,
    required this.weapon,
    required this.trainingDao,
    required this.training,
  });

  @override
  State<TrainingListRow> createState() => _TrainingListRowState();
}

class _TrainingListRowState extends State<TrainingListRow> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 20,
      leading: SizedBox(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _getTrainingIcon(widget.training),
              _getTrainingPoints(widget.training)
            ],
          )),
      title: Text(widget.training.kind),
      subtitle: Text(
          "${DateFormat.yMMMd().format(widget.training.date)}, in ${widget.training.place}"),
      trailing: IconButton(
          onPressed: () {
            _deleteTraining();
          },
          icon: const Icon(Icons.delete)),
      onTap: () {
        showBarModalBottomSheet(
          context: context,
          expand: true,
          builder: (context) => TrainingEditWidget(
              weapon: widget.weapon,
              trainingDao: widget.trainingDao,
              training: widget.training),
        );
      },
    );
  }

  void _deleteTraining() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog.adaptive(
            title: Text(tr("training_alert_title")),
            content: Text(tr("training_alert_message")),
            actions: [
              TextButton(
                  onPressed: () {
                    widget.trainingDao.deleteTraining(widget.training);

                    final scaffoldMessengerState =
                        ScaffoldMessenger.of(context);
                    scaffoldMessengerState.hideCurrentSnackBar();
                    scaffoldMessengerState.showSnackBar(
                      SnackBar(
                          content: Text(tr("training_removed")),
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

  Icon _getTrainingIcon(Training training) {
    switch (training.indicator) {
      case 0:
        return IndicatorImage.getIcon(0);
      case 1:
        return IndicatorImage.getIcon(1);
      case 2:
        return IndicatorImage.getIcon(2);
      case 3:
        return IndicatorImage.getIcon(3);
      default:
        return const Icon(Icons.error);
    }
  }

  Text _getTrainingPoints(Training training) {
    if (training.shots.isNotEmpty) {
      if (training.shots.any((element) => element is double)) {
        return Text(
          training.shots
              .reduce((value, next) => value + next)
              .toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      } else {
        num shots = training.shots.reduce((value, next) =>
            (value != null && next != null) ? value + next : value + 0);
        return Text(shots.toStringAsFixed(0),
            style: const TextStyle(fontWeight: FontWeight.bold));
      }
    } else {
      return const Text("0", style: TextStyle(fontWeight: FontWeight.bold));
    }
  }
}
