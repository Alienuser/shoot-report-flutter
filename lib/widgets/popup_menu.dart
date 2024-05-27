import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shoot_report/main.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/widgets/cooperation.dart';
import 'package:shoot_report/widgets/information.dart';
import 'package:shoot_report/widgets/partner.dart';
import 'package:status_alert/status_alert.dart';
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
        /*PopupMenuItem<int>(
          value: 5,
          child: Text(tr("menu_import")),
        ),*/
        PopupMenuItem<int>(
          value: 6,
          child: Text(tr("menu_export")),
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
          case 5:
            FirebaseLog().logEvent("Import Database");
            importDatabase();
            break;
          case 6:
            FirebaseLog().logEvent("Export Database");
            Share.shareXFiles([XFile(database.database.database.path)],
                text: tr("training_share_text"));
            break;
        }
      },
    );
  }

  void importDatabase() async {
    // Get the new database
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.extension == "db") {
        Uint8List? fileBytes = result.files.first.bytes;

        // Override the old database
        await FileSaver.instance.saveFile(
            name: "flutter_shoot_report.db",
            bytes: fileBytes,
            filePath: database.database.database.path);

        if (mounted) {
          StatusAlert.show(
            context,
            duration: const Duration(seconds: 6),
            title: tr("import_database_alert_title"),
            subtitle: tr("import_database_alert_message"),
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            configuration: const FlareConfiguration(
                'assets/animations/success.flr',
                animation: 'check',
                margin: EdgeInsets.zero,
                color: Colors.green),
          );
        }
      } else {
        if (mounted) {
          StatusAlert.show(
            context,
            duration: const Duration(seconds: 8),
            title: tr("import_database_alert_error_title"),
            subtitle: tr("import_database_alert_error_message"),
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
          );
        }
      }
    }
  }
}
