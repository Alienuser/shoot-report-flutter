import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/newWeapon.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/weapon/weapon_row.dart';

class WeaponListView extends StatelessWidget {
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const WeaponListView({
    super.key,
    required this.weaponDao,
    required this.trainingDao,
    required this.competitionDao,
  });

  @override
  Widget build(BuildContext context) {
    final Query weaponsRef = FirebaseDatabase.instance
        .ref('${FirebaseAuth.instance.currentUser?.uid}')
        .child('weapons')
        .orderByChild('show')
        .equalTo(true);

    return Expanded(
      child: StreamBuilder<DatabaseEvent>(
        stream: weaponsRef.onValue, // Stream von Firebase Realtime Database
        builder: (_, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const SizedBox(); // Zeige nichts an, wenn keine Daten vorhanden sind
          }

          // Extrahiere die Daten aus dem Snapshot
          final weaponsData =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          if (weaponsData.isEmpty) {
            final ThemeData mode = Theme.of(context);
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(
                    Icons.legend_toggle_sharp,
                    color: (mode.brightness == Brightness.light)
                        ? const Color(AppTheme.primaryColor)
                        : const Color(AppTheme.backgroundLight),
                    size: 120,
                  ),
                  Text(
                    tr("weapon_data_no"),
                    textAlign: TextAlign.center,
                  )
                ]));
          }

          // Konvertiere die Daten in eine Liste von Weapon-Objekten
          final weapons = weaponsData.entries.map((entry) {
            return NewWeapon.fromJson(
                entry.key, Map<String, dynamic>.from(entry.value));
          }).toList();

          return ListView.separated(
              itemCount: weapons.length,
              itemBuilder: (context, index) {
                return WeaponListCell(
                  newWeapon: weapons[index],
                  weapon: Weapon(1, "", 0, "", true),
                  weaponDao:
                      weaponDao, // Keine lokale Datenbank mehr, daher null
                  trainingDao: trainingDao,
                  competitionDao: competitionDao,
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 5));
        },
      ),
    );
  }
}
