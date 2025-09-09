import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/views/discipline/discipine_type.dart';
import 'package:shoot_report/views/weapon/weapon_list.dart';
import 'package:shoot_report/widgets/ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/widgets/popup_menu.dart';

class WeaponWidget extends StatefulWidget {
  const WeaponWidget({super.key});

  @override
  State<WeaponWidget> createState() => _WeaponWidgetState();
}

class _WeaponWidgetState extends State<WeaponWidget> {
  @override
  void initState() {
    super.initState();
    FirebaseLog().logScreenView("weapon.dart", "weapon");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(tr("general_title")),
            centerTitle: false,
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.star_border),
                  color: Colors.white,
                  tooltip: tr("weapon_favorite_toolltip"),
                  onPressed: () {
                    showBarModalBottomSheet(
                        context: context,
                        expand: true,
                        enableDrag: true,
                        builder: (context) => const DisciplineTypeListView());
                  }),
              const PopupMenuWidget()
            ]),
        body: Column(children: <Widget>[
          const WeaponListView()
        ]),
        bottomNavigationBar: const AdsWidget());
  }
}
