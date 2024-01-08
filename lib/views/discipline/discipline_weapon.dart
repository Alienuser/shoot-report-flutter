import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/discipline/discipline_weapon_row.dart';
import 'package:shoot_report/models/type.dart';

class DisciplineWeaponListView extends StatelessWidget {
  final Type type;
  final WeaponDao weaponDao;

  const DisciplineWeaponListView(
      {super.key, required this.type, required this.weaponDao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(tr(type.name)),
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Icon(Icons.close),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(null)),
          ],
        ),
        body: Material(
          child: StreamBuilder<List<Weapon>>(
            stream: weaponDao.findAllWeaponsForType(type.id!),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final weapons = snapshot.requireData;

              return ListView.separated(
                itemCount: weapons.length,
                itemBuilder: (context, index) {
                  return DisciplineWeaponListCell(
                      weapon: weapons[index], weaponDao: weaponDao);
                },
                separatorBuilder: (context, index) => const Divider(height: 5),
              );
            },
          ),
        ));
  }
}
