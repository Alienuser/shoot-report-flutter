import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CooperationWidget extends StatefulWidget {
  const CooperationWidget({super.key});

  @override
  State<CooperationWidget> createState() => _CooperationWidgetState();
}

class _CooperationWidgetState extends State<CooperationWidget> {
  @override
  void initState() {
    super.initState();
    FirebaseLog().logScreenView("cooperation.dart", "cooperation");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return Material(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                tr("cooperation_title"),
                style: const TextStyle(fontSize: 25),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(null),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CupertinoFormSection.insetGrouped(
                      backgroundColor: Colors.transparent,
                      header: Text(tr("cooperation_list_title"),
                          style: const TextStyle(
                              color: Color(AppTheme.accentColor),
                              fontSize: 15)),
                      children: [
                        Container(
                          color: (mode.brightness == Brightness.light)
                              ? Colors.transparent
                              : const Color(AppTheme.backgroundAdsDark),
                          child: InkWell(
                              onTap: () {
                                launchUrl(
                                  Uri.parse("https://www.kksvillingen.de"),
                                  mode: LaunchMode.externalApplication,
                                );
                                FirebaseLog()
                                    .logEvent("Cooperation - KKSV Illingen");
                              },
                              child: CupertinoFormRow(
                                padding: const EdgeInsets.all(10),
                                prefix: Container(),
                                helper: Center(
                                    child: Image.asset(
                                        "assets/images/partner_kksvilligen.png",
                                        height: 40)),
                                child: Container(),
                              )),
                        )
                      ]),
                  CupertinoFormSection.insetGrouped(
                      backgroundColor: Colors.transparent,
                      decoration: const BoxDecoration(),
                      header: Text(tr("cooperation_action_title"),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(AppTheme.accentColor),
                          ),
                          onPressed: () {
                            launchUrl(
                              Uri.parse(
                                  "https://www.burkhardt-sport.solutions/kontakt"),
                              mode: LaunchMode.externalApplication,
                            );
                            FirebaseLog().logEvent(
                                "Cooperation - Burkhardt Sport Solutions");
                          },
                          child: Text(tr("cooperation_action_contact")),
                        ),
                      ]),
                ],
              ),
            )));
  }
}
