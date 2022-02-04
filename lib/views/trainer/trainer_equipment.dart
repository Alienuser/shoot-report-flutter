import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/trainer/trainer_view.dart';

class TrainerEquipmentWidget extends StatelessWidget {
  const TrainerEquipmentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr("trainer_title")),
          centerTitle: false,
          bottom: TabBar(
            indicatorColor: const Color(CompanyColors.accentColor),
            tabs: <Widget>[
              Tab(text: tr("trainer_tab_equipment_clothes")),
              Tab(text: tr("trainer_tab_equipment_equipment")),
              Tab(text: tr("trainer_tab_equipment_accessories")),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            TrainerViewWidget(url: "equipment_cloths.html"),
            TrainerViewWidget(url: "equipment_sport.html"),
            TrainerViewWidget(url: "equipment_equipment.html"),
          ],
        ),
      ),
    );
  }
}
