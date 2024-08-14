import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/firebase.dart';
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
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("${FirebaseAuth.instance.currentUser?.uid}/weapons")
            .orderByChild('show')
            .equalTo(true)
            .onValue,
        builder: (_, snapshot) {
          if (!snapshot.hasData || snapshot.data.toString() == "[]") {
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

          var data = snapshot.data!.snapshot.value as Map;
          List<NewWeapon> weapons = List.empty(growable: true);
          data.forEach((key, value) {
            weapons.add(NewWeapon(key, value["name"], 1, "", value["show"]));
          });

          return ListView.separated(
              itemCount: weapons.length,
              itemBuilder: (context, index) {
                return WeaponListCell(
                    newWeapon: weapons[index],
                    weapon: Weapon(0, "", 0, "", true),
                    weaponDao: weaponDao,
                    trainingDao: trainingDao,
                    competitionDao: competitionDao);
              },
              separatorBuilder: (context, index) => const Divider(height: 5));
        },
      ),
    );
  }
}
