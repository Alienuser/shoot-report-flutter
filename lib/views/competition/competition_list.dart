import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/competition/competition_add.dart';
import 'package:shoot_report/views/competition/competition_row.dart';

class CompetitionListWidget extends StatelessWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;
  final CompetitionDao competitionDao;

  const CompetitionListWidget(
      {Key? key,
      required this.weapon,
      required this.weaponDao,
      required this.competitionDao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Competition>>(
        stream: competitionDao.findAllCompetitionForWeapon(weapon.id!),
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
                    tr("competition_data_no"),
                    textAlign: TextAlign.center,
                  )
                ]));
          }

          final competitions = snapshot.requireData;

          return ListView.separated(
            itemCount: competitions.length,
            itemBuilder: (context, index) {
              return CompetitionListRow(
                  weapon: weapon,
                  competitionDao: competitionDao,
                  competition: competitions[index]);
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 5);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBarModalBottomSheet(
            context: context,
            expand: true,
            builder: (context) => CompetitionAddWidget(
                weapon: weapon, competitionDao: competitionDao),
          );
        },
        backgroundColor: const Color(AppTheme.accentColor),
        child: const Icon(Icons.add),
      ),
    );
  }
}
