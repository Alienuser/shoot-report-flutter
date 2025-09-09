import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/firebase_data_service.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/competition/competition_add.dart';
import 'package:shoot_report/views/competition/competition_row.dart';

class CompetitionListWidget extends StatelessWidget {
  final Weapon weapon;

  const CompetitionListWidget({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<Map<String, dynamic>?>(
            stream: FirebaseDataService.getUserCompetitionsStream(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                final ThemeData mode = Theme.of(context);
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(
                        Icons.emoji_events,
                        color: (mode.brightness == Brightness.light)
                            ? const Color(AppTheme.primaryColor)
                            : const Color(AppTheme.backgroundLight),
                        size: 120,
                      ),
                      Text(tr("competition_data_no"),
                          textAlign: TextAlign.center)
                    ]));
              }

              final competitionsData = snapshot.data!;
              final competitions = competitionsData.entries
                  .where((entry) {
                    final data = Map<String, dynamic>.from(entry.value as Map);
                    return data['weaponId'] == weapon.id!;
                  })
                  .map((entry) {
                    final data = Map<String, dynamic>.from(entry.value as Map);
                    final competition = Competition(
                      null,
                      DateTime.fromMillisecondsSinceEpoch(data['date']),
                      data['image'] ?? '',
                      data['place'] ?? '',
                      data['kind'] ?? '',
                      data['shotCount'] ?? 0,
                      data['shots'] ?? [],
                      data['comment'] ?? '',
                      data['weaponId'] ?? weapon.id!,
                    );
                    // Store Firebase key for deletion/update
                    competition.firebaseKey = entry.key;
                    return competition;
                  }).toList();
              
              competitions.sort((a, b) => b.date.compareTo(a.date));
              
              if (competitions.isEmpty) {
                final ThemeData mode = Theme.of(context);
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(
                        Icons.emoji_events,
                        color: (mode.brightness == Brightness.light)
                            ? const Color(AppTheme.primaryColor)
                            : const Color(AppTheme.backgroundLight),
                        size: 120,
                      ),
                      Text(tr("competition_data_no"),
                          textAlign: TextAlign.center)
                    ]));
              }

              return ListView.separated(
                  itemCount: competitions.length,
                  itemBuilder: (context, index) {
                    return CompetitionListRow(
                        weapon: weapon,
                        competition: competitions[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 0);
                  });
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showBarModalBottomSheet(
                context: context,
                expand: true,
                builder: (context) => CompetitionAddWidget(weapon: weapon),
              );
            },
            backgroundColor: const Color(AppTheme.accentColor),
            child: const Icon(Icons.add)));
  }
}
