import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/weapon_dao.dart';

class DisciplineWeaponListCell extends StatelessWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;

  const DisciplineWeaponListCell({
    Key? key,
    required this.weapon,
    required this.weaponDao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset("assets/images/disciplines.png", height: 16),
      title: Text(tr(weapon.name)),
      trailing: IconButton(
          onPressed: () {
            _updateFavorite(weapon);
          },
          icon: Icon(weapon.show ? Icons.star : Icons.star_outline)),
    );
  }

  void _updateFavorite(Weapon weapon) {
    weapon.show = !weapon.show;
    weaponDao.updateWeapon(weapon);
  }
}
