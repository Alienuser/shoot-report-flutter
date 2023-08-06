import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/favorite/favorite_sub_row.dart';
import 'package:shoot_report/models/type.dart';

class FavoriteListSubView extends StatelessWidget {
  final Type type;
  final WeaponDao weaponDao;

  const FavoriteListSubView(
      {Key? key, required this.type, required this.weaponDao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
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
              return FavoriteSubListCell(
                  weapon: weapons[index], weaponDao: weaponDao);
            },
            separatorBuilder: (context, index) => const Divider(height: 5),
          );
        },
      ),
    );
  }
}
