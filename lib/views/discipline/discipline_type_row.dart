import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/type.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/discipline/discipline_weapon.dart';

class DisciplineTypeListCell extends StatelessWidget {
  final Type type;
  final WeaponDao weaponDao;

  const DisciplineTypeListCell({
    Key? key,
    required this.type,
    required this.weaponDao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.asset("assets/images/disciplines.png", height: 16),
        title: Text(tr(type.name)),
        trailing: const Icon(Icons.arrow_right_sharp, size: 35),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DisciplineWeaponListView(type: type, weaponDao: weaponDao)),
          );
        });
  }
}
