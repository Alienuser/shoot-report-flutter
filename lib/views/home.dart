import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/competition/competition.dart';
import 'package:shoot_report/views/data/data.dart';
import 'package:shoot_report/views/goals/goals.dart';
import 'package:shoot_report/views/procedure/procedure.dart';
import 'package:shoot_report/views/trainer/trainer.dart';
import 'package:shoot_report/views/training/training.dart';
import 'package:shoot_report/widgets/Partner.dart';
import 'package:shoot_report/widgets/cooperation.dart';
import 'package:shoot_report/widgets/information.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatefulWidget {
  final Weapon weapon;
  final WeaponDao weaponDao;
  final TrainingDao trainingDao;
  final CompetitionDao competitionDao;

  const HomeWidget(
      {Key? key,
      required this.weapon,
      required this.weaponDao,
      required this.trainingDao,
      required this.competitionDao})
      : super(key: key);

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
    List<Widget> _widgetOptions = <Widget>[
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
      appBar: AppBar(
        title: Text(tr(widget.weapon.name)),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
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
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(tr("menu_information")),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text(tr("menu_partner")),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text(tr("menu_cooperation")),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text(tr("menu_facebook")),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Text(tr("menu_instagram")),
              ),
            ],
            onSelected: (item) {
              switch (item) {
                case 0:
                  showCupertinoModalBottomSheet(
                    expand: true,
                    context: context,
                    builder: (context) => const InformationWidget(),
                  );
                  break;
                case 1:
                  showCupertinoModalBottomSheet(
                    context: context,
                    expand: true,
                    builder: (context) => const PartnerWidget(),
                  );
                  break;
                case 2:
                  showCupertinoModalBottomSheet(
                    context: context,
                    expand: true,
                    builder: (context) => const CooperationWidget(),
                  );
                  break;
                case 3:
                  launch(
                    "https://facebook.com/shoot.report",
                    forceSafariVC: false,
                    forceWebView: false,
                  );
                  break;
                case 4:
                  launch(
                    "https://instagram.com/shoot.report",
                    forceSafariVC: false,
                    forceWebView: false,
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
    );
  }
}
