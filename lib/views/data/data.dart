import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:shoot_report/views/data/data_device.dart';
import 'package:shoot_report/views/data/data_person.dart';
import 'package:shoot_report/widgets/ads.dart';

class DataWidget extends StatelessWidget {
  const DataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(tr("data_title")),
            centerTitle: false,
            bottom: TabBar(
              indicator: const UnderlineTabIndicator(
                  borderSide:
                      BorderSide(width: 4, color: Color(AppTheme.accentColor))),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              tabs: <Widget>[
                Tab(text: tr("data_tab_person")),
                Tab(text: tr("data_tab_device")),
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[
              DataPersonWidget(),
              DataDeviceWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdsWidget(),
    );
  }
}
