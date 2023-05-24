import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/favorite/favorite_row.dart';

class FavoriteListView extends StatelessWidget {
  final WeaponDao weaponDao;

  const FavoriteListView({Key? key, required this.weaponDao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder<List<Weapon>>(
        stream: weaponDao.findAllWeapons(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          final weapons = snapshot.requireData;

          return ListView.separated(
            itemCount: weapons.length,
            itemBuilder: (context, index) {
              return FavoriteListCell(
                  weapon: weapons[index], weaponDao: weaponDao);
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