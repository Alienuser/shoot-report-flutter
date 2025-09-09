import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/type.dart';
import 'package:shoot_report/views/discipline/discipline_weapon.dart';

class DisciplineTypeListCell extends StatelessWidget {
  final Type type;

  const DisciplineTypeListCell({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.asset("assets/images/disciplines_type.png", height: 16),
        title: Text(tr(type.name)),
        trailing: const Icon(Icons.arrow_right_sharp, size: 35),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisciplineWeaponListView(type: type)));
        });
  }
}