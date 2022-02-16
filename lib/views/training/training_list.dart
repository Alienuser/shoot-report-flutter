import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/training/training_add.dart';
import 'package:shoot_report/views/training/training_row.dart';

class TrainingListWidget extends StatelessWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;

  const TrainingListWidget(
      {Key? key,
      required this.weapon,
      required this.weaponDao,
      required this.trainingDao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Training>>(
        stream: trainingDao.findAllTrainingsForWeapon(weapon.id!),
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
                    Icons.hourglass_empty,
                    color: Color(AppTheme.primaryColor),
                    size: 120,
                  ),
                  Text(
                    tr("training_data_no"),
                    textAlign: TextAlign.center,
                  )
                ]));
          }

          final trainings = snapshot.requireData;

          return ListView.separated(
            itemCount: trainings.length,
            itemBuilder: (context, index) {
              return TrainingListRow(
                  weapon: weapon,
                  trainingDao: trainingDao,
                  training: trainings[index]);
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 0);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBarModalBottomSheet(
            context: context,
            expand: true,
            builder: (context) =>
                TrainingAddWidget(weapon: weapon, trainingDao: trainingDao),
          );
        },
        backgroundColor: const Color(AppTheme.accentColor),
        child: const Icon(Icons.add),
      ),
    );
  }
}
