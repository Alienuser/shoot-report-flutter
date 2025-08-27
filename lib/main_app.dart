import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/type_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/weapon/weapon.dart';

class ShootReport extends StatelessWidget {
  final TypeDao typeDao;
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const ShootReport({
    super.key,
    required this.typeDao,
    required this.weaponDao,
    required this.trainingDao,
    required this.competitionDao,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) {
          return SafeArea(
            top: false,
            bottom: true,
            child: child!,
          );
        },
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: WeaponWidget(
          typeDao: typeDao,
          weaponDao: weaponDao,
          trainingDao: trainingDao,
          competitionDao: competitionDao,
        ));
  }
}
