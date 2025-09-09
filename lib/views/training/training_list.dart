import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/firebase_data_service.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/training/training_add.dart';
import 'package:shoot_report/views/training/training_row.dart';

class TrainingListWidget extends StatelessWidget {
  final Weapon weapon;

  const TrainingListWidget({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<Map<String, dynamic>?>(
            stream: FirebaseDataService.getUserTrainingsStream(),
            builder: (_, snapshot) {


              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                final ThemeData mode = Theme.of(context);
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(
                        Icons.fitness_center,
                        color: (mode.brightness == Brightness.light)
                            ? const Color(AppTheme.primaryColor)
                            : const Color(AppTheme.backgroundLight),
                        size: 120,
                      ),
                      Text(
                        tr("training_data_no"),
                        textAlign: TextAlign.center,
                      )
                    ]));
              }

              final trainingsData = snapshot.data!;
              final trainings = trainingsData.entries.where((entry) {
                final data = Map<String, dynamic>.from(entry.value as Map);
                return data['weaponId'] == weapon.id!;
              }).map((entry) {
                final data = Map<String, dynamic>.from(entry.value as Map);
                final training = Training(
                  null,
                  DateTime.fromMillisecondsSinceEpoch(data['date']),
                  data['image'] ?? '',
                  data['indicator'] ?? 2,
                  data['place'] ?? '',
                  data['kind'] ?? '',
                  data['shotCount'] ?? 0,
                  data['shots'] ?? [],
                  data['comment'] ?? '',
                  data['weaponId'] ?? weapon.id!,
                );
                // Store Firebase key for deletion
                training.firebaseKey = entry.key;
                return training;
              }).toList();

              trainings.sort((a, b) => b.date.compareTo(a.date));

              if (trainings.isEmpty) {
                final ThemeData mode = Theme.of(context);
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(
                        Icons.fitness_center,
                        color: (mode.brightness == Brightness.light)
                            ? const Color(AppTheme.primaryColor)
                            : const Color(AppTheme.backgroundLight),
                        size: 120,
                      ),
                      Text(
                        tr("training_data_no"),
                        textAlign: TextAlign.center,
                      )
                    ]));
              }

              return ListView.separated(
                  itemCount: trainings.length,
                  itemBuilder: (context, index) {
                    return TrainingListRow(
                        weapon: weapon, training: trainings[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 0);
                  });
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showBarModalBottomSheet(
                  context: context,
                  expand: true,
                  builder: (context) => TrainingAddWidget(weapon: weapon));
            },
            backgroundColor: const Color(AppTheme.accentColor),
            child: const Icon(Icons.add)));
  }
}
