import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/trainer/trainer_view.dart';

class TrainerTechWidget extends StatelessWidget {
  const TrainerTechWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr("trainer_title")),
          centerTitle: false,
          bottom: TabBar(
            indicator: const UnderlineTabIndicator(
                borderSide:
                    BorderSide(width: 4, color: Color(AppTheme.accentColor))),
            labelColor: Colors.white,
            tabs: <Widget>[
              Tab(text: tr("trainer_tab_tech_positioning")),
              Tab(text: tr("trainer_tab_tech_procedure")),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            TrainerViewWidget(url: "tech_positioning.html"),
            TrainerViewWidget(url: "tech_procedure.html"),
          ],
        ),
      ),
    );
  }
}
