import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/views/training/training_edit.dart';

class TrainingListRow extends StatefulWidget {
  final Weapon weapon;
  final TrainingDao trainingDao;
  final Training training;

  const TrainingListRow({
    Key? key,
    required this.weapon,
    required this.trainingDao,
    required this.training,
  }) : super(key: key);

  @override
  State<TrainingListRow> createState() => _TrainingListRowState();
}

class _TrainingListRowState extends State<TrainingListRow> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${widget.training.hashCode}'),
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
        widget.trainingDao.deleteTraining(widget.training);

        final scaffoldMessengerState = ScaffoldMessenger.of(context);
        scaffoldMessengerState.hideCurrentSnackBar();
        scaffoldMessengerState.showSnackBar(
          SnackBar(content: Text(tr("training_removed"))),
        );
      },
      child: ListTile(
        leading: Wrap(
          spacing: 20,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            getTrainingIcon(widget.training),
            getTrainingPoints(widget.training)
          ],
        ),
        title: Text(widget.training.kind),
        subtitle: Text(
            "${DateFormat.yMd().format(widget.training.date)}, in ${widget.training.place}"),
        onTap: () {
          showCupertinoModalBottomSheet(
            context: context,
            expand: true,
            builder: (context) => TrainingEditWidget(
                weapon: widget.weapon,
                trainingDao: widget.trainingDao,
                training: widget.training),
          );
        },
      ),
    );
  }

  Icon getTrainingIcon(Training training) {
    switch (training.indicator) {
      case 0:
        return const Icon(Icons.sentiment_dissatisfied_outlined,
            color: Colors.red);
      case 1:
        return const Icon(Icons.sentiment_dissatisfied, color: Colors.red);
      case 2:
        return const Icon(Icons.sentiment_neutral_outlined,
            color: Colors.yellow);
      case 3:
        return const Icon(Icons.sentiment_satisfied, color: Colors.green);
      default:
        return const Icon(Icons.error);
    }
  }

  Text getTrainingPoints(Training training) {
    if (training.shots.any((element) => element is int)) {
      return Text(training.shots
          .reduce((value, next) => value + next)
          .toStringAsFixed(1));
    } else {
      return Text(training.shots
          .reduce((value, next) => value + next)
          .toStringAsFixed(1));
    }
  }
}
