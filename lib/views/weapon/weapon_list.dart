import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/app_migration.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/weapon/weapon_row.dart';

class WeaponListView extends StatelessWidget {
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const WeaponListView({
    Key? key,
    required this.weaponDao,
    required this.trainingDao,
    required this.competitionDao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Weapon>>(
        stream: weaponDao.findAllWeaponsDistinction(true),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          if (snapshot.data.toString() == "[]") {
            final ThemeData mode = Theme.of(context);
            AppMigration.loadDefaultWeapons(weaponDao);
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

          final weapons = snapshot.requireData;

          return ListView.separated(
            itemCount: weapons.length,
            itemBuilder: (context, index) {
              return WeaponListCell(
                  weapon: weapons[index],
                  weaponDao: weaponDao,
                  trainingDao: trainingDao,
                  competitionDao: competitionDao);
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 5);
            },
          );
        },
      ),
    );
  }
}
