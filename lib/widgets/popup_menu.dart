import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/widgets/cooperation.dart';
import 'package:shoot_report/widgets/information.dart';
import 'package:shoot_report/widgets/partner.dart';
import 'package:url_launcher/url_launcher.dart';

class PopupMenuWidget extends StatefulWidget {
  const PopupMenuWidget({super.key});

  @override
  State<StatefulWidget> createState() => _PopupMenuWidget();
}

class _PopupMenuWidget extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
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
              showBarModalBottomSheet(
                expand: true,
                context: context,
                builder: (context) => const InformationWidget(),
              );
              break;
            case 1:
              showBarModalBottomSheet(
                context: context,
                expand: true,
                builder: (context) => const PartnerWidget(),
              );
              break;
            case 2:
              showBarModalBottomSheet(
                context: context,
                expand: true,
                builder: (context) => const CooperationWidget(),
              );
              break;
            case 3:
              FirebaseLog().logEvent("Facebook");
              launchUrl(
                Uri.parse("https://facebook.com/shoot.report"),
                mode: LaunchMode.externalApplication,
              );
              break;
            case 4:
              FirebaseLog().logEvent("Instagram");
              launchUrl(
                Uri.parse("https://instagram.com/shoot.report"),
                mode: LaunchMode.externalApplication,
              );
              break;

          }
        });
  }


}
