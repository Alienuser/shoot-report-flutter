import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/trainer/trainer_view.dart';

class TrainerMentalWidget extends StatelessWidget {
  const TrainerMentalWidget({
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
            indicator: const UnderlineTabIndicator(
                borderSide:
                    BorderSide(width: 4, color: Color(AppTheme.accentColor))),
            labelColor: Colors.white,
            tabs: <Widget>[
              Tab(text: tr("trainer_tab_mental_rest")),
              Tab(text: tr("trainer_tab_mental_motivation")),
              Tab(text: tr("trainer_tab_mental_focus")),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            TrainerViewWidget(url: "mental_relax.html"),
            TrainerViewWidget(url: "mental_motivation.html"),
            TrainerViewWidget(url: "mental_focus.html"),
          ],
        ),
      ),
    );
  }
}
