import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/views/trainer/trainer_equipment.dart';
import 'package:shoot_report/views/trainer/trainer_mental.dart';
import 'package:shoot_report/views/trainer/trainer_tech.dart';
import 'package:shoot_report/widgets/ads.dart';

class TrainerWidget extends StatefulWidget {
  const TrainerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TrainerWidget> createState() => _TrainerWidgetState();
}

class _TrainerWidgetState extends State<TrainerWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      const TrainerEquipmentWidget(),
      const TrainerTechWidget(),
      const TrainerMentalWidget(),
    ];

    return Scaffold(
      body: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.work),
              label: tr("trainer_tab_equipment"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.miscellaneous_services),
              label: tr("trainer_tab_tech"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.psychology),
              label: tr("trainer_tab_mental"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdsWidget(),
    );
  }
}
