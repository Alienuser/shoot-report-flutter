import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/weapon_dao.dart';

class FavoriteSubListCell extends StatelessWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;

  const FavoriteSubListCell({
    Key? key,
    required this.weapon,
    required this.weaponDao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.legend_toggle_sharp),
      title: Text(tr(weapon.name)),
      trailing: IconButton(
          onPressed: () {
            _updateFavorite(weapon);
          },
          icon: Icon(weapon.favorite ? Icons.star : Icons.star_outline)),
    );
  }

  void _updateFavorite(Weapon weapon) {
    weapon.favorite = !weapon.favorite;
    weaponDao.updateWeapon(weapon);
  }
}
