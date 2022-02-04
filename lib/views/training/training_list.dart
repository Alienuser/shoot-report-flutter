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
            return const Text("Daten werden geladen...");
          }
          if (snapshot.data.toString() == "[]") {
            return const Text('Keine Daten da...');
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
              return const Divider(height: 5);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalBottomSheet(
            context: context,
            expand: true,
            builder: (context) => TrainingAddWidget(weapon: weapon),
          );
        },
        backgroundColor: const Color(CompanyColors.accentColor),
        child: const Icon(Icons.add),
      ),
    );
  }
}
