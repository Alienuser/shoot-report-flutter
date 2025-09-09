import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/firebase_data_service.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/weapon/weapon_row.dart';

class WeaponListView extends StatelessWidget {
  const WeaponListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: FirebaseDataService.getVisibleWeaponsStream(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Connection Error'),
                    ],
                  ),
                );
              }
              
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final weaponsData = snapshot.data!;
              if (weaponsData.isEmpty) {
                final ThemeData mode = Theme.of(context);
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
              
              final weapons = weaponsData.map((data) {
                return Weapon(
                  data['id'],
                  data['name'],
                  data['order'],
                  data['prefFile'],
                  data['typeId'],
                  true, // Always true for visible weapons
                );
              }).toList();
              
              return ListView.separated(
                  itemCount: weapons.length,
                  itemBuilder: (context, index) {
                    return WeaponListCell(weapon: weapons[index]);
                  },
                  separatorBuilder: (context, index) => const Divider(height: 5));
            }));
  }
}
