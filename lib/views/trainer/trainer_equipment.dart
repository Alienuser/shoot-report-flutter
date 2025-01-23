import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/trainer/trainer_view.dart';
import 'package:easy_localization/easy_localization.dart';

class TrainerEquipmentWidget extends StatelessWidget {
  const TrainerEquipmentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                title: Text(tr("trainer_title")),
                centerTitle: false,
                leading: const BackButton(color: Colors.white),
                bottom: TabBar(
                    indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(
                            width: 4, color: Color(AppTheme.accentColor))),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    tabs: <Widget>[
                      Tab(text: tr("trainer_tab_equipment_clothes")),
                      Tab(text: tr("trainer_tab_equipment_equipment")),
                      Tab(text: tr("trainer_tab_equipment_accessories"))
                    ])),
            body: const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  TrainerViewWidget(url: "equipment_cloths.html"),
                  TrainerViewWidget(url: "equipment_sport.html"),
                  TrainerViewWidget(url: "equipment_equipment.html")
                ])));
  }
}
