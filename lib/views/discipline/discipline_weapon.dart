import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/type.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/firebase_data_service.dart';
import 'package:shoot_report/views/discipline/discipline_weapon_row.dart';

class DisciplineWeaponListView extends StatelessWidget {
  final Type type;

  const DisciplineWeaponListView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(tr(type.name)),
            leading: const BackButton(color: Colors.white)),
        body: FutureBuilder<Map<String, dynamic>?>(
            future: FirebaseDataService.getGlobalWeapons(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final weaponsData = snapshot.data;
              if (weaponsData == null || weaponsData.isEmpty) {
                return const Center(child: Text('No weapons available'));
              }

              final weapons = weaponsData.entries
                  .where((entry) {
                    final data = entry.value;
                    Map<String, dynamic> weaponData;
                    if (data is Map<String, dynamic>) {
                      weaponData = data;
                    } else if (data is Map) {
                      weaponData = Map<String, dynamic>.from(data);
                    } else {
                      return false;
                    }
                    return weaponData['typeId'] == type.id;
                  })
                  .map((entry) {
                    final data = entry.value;
                    Map<String, dynamic> weaponData;
                    if (data is Map<String, dynamic>) {
                      weaponData = data;
                    } else if (data is Map) {
                      weaponData = Map<String, dynamic>.from(data);
                    } else {
                      return null;
                    }
                    return Weapon(
                      weaponData['id'],
                      weaponData['name'],
                      weaponData['order'],
                      weaponData['prefFile'],
                      weaponData['typeId'],
                      weaponData['show'] ?? true,
                    );
                  })
                  .where((weapon) => weapon != null)
                  .cast<Weapon>()
                  .toList();

              weapons.sort((a, b) => a.order.compareTo(b.order));

              return ListView.separated(
                  itemCount: weapons.length,
                  itemBuilder: (context, index) {
                    return DisciplineWeaponListCell(weapon: weapons[index]);
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: 5));
            }));
  }
}