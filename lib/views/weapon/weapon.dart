import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/favorite/favorite.dart';
import 'package:shoot_report/views/weapon/weapon_list.dart';
import 'package:shoot_report/widgets/ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class WeaponWidget extends StatefulWidget {
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const WeaponWidget({
    Key? key,
    required this.weaponDao,
    required this.trainingDao,
    required this.competitionDao,
  }) : super(key: key);

  @override
  State<WeaponWidget> createState() => _WeaponWidgetState();
}

class _WeaponWidgetState extends State<WeaponWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("general_title")),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite),
            color: Colors.white,
            tooltip: tr("weapon_favorite_toolltip"),
            onPressed: () {
              showBarModalBottomSheet(
                  context: context,
                  expand: true,
                  enableDrag: false,
                  builder: (context) =>
                      FavoriteListView(weaponDao: widget.weaponDao));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          WeaponListView(
            weaponDao: widget.weaponDao,
            trainingDao: widget.trainingDao,
            competitionDao: widget.competitionDao,
          ),
        ],
      ),
      bottomNavigationBar: const AdsWidget(),
    );
  }
}
