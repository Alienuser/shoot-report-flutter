import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/competition/competition.dart';
import 'package:shoot_report/views/data/data.dart';
import 'package:shoot_report/views/goals/goals.dart';
import 'package:shoot_report/views/procedure/procedure.dart';
import 'package:shoot_report/views/trainer/trainer.dart';
import 'package:shoot_report/views/training/training.dart';
import 'package:shoot_report/widgets/ads.dart';
import 'package:shoot_report/widgets/popup_menu.dart';

class HomeWidget extends StatefulWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const HomeWidget({
    super.key,
    required this.weapon,
    required this.weaponDao,
    required this.trainingDao,
    required this.competitionDao,
  });

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      TrainingWidget(
          weapon: widget.weapon,
          weaponDao: widget.weaponDao,
          trainingDao: widget.trainingDao),
      CompetitionWidget(
        weapon: widget.weapon,
        weaponDao: widget.weaponDao,
        competitionDao: widget.competitionDao,
      ),
      ProcedureWidget(weapon: widget.weapon),
      GoalsWidget(weapon: widget.weapon),
    ];

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text(tr(widget.weapon.name)),
          centerTitle: false,
          leading: const BackButton(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle),
              color: Colors.white,
              tooltip: tr("tooltip_user"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DataWidget(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.sports),
              color: Colors.white,
              tooltip: tr("tooltip_trainer"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainerWidget(),
                  ),
                );
              },
            ),
            const PopupMenuWidget()
          ],
        ),
        body: Center(
          child: Container(
            child: widgetOptions.elementAt(_selectedIndex),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center),
              label: tr("menu_bottom_training"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.emoji_events),
              label: tr("menu_bottom_competition"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.format_list_bulleted),
              label: tr("menu_bottom_procedure"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.flag),
              label: tr("menu_bottom_goals"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdsWidget(),
    );
  }
}
