import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerWidget extends StatefulWidget {
  const PartnerWidget({super.key});

  @override
  State<PartnerWidget> createState() => _PartnerWidgetState();
}

class _PartnerWidgetState extends State<PartnerWidget> {
  @override
  void initState() {
    super.initState();
    FirebaseLog().logScreenView("partner.dart", "partner");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return Material(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                tr("partner_title"),
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
                    header: Text(tr("partner_list_title"),
                        style: const TextStyle(
                            color: Color(AppTheme.accentColor), fontSize: 15)),
                    children: [
                      Container(
                          color: (mode.brightness == Brightness.light)
                              ? Colors.transparent
                              : const Color(AppTheme.backgroundAdsDark),
                          child: InkWell(
                              onTap: () {
                                launchUrl(
                                  Uri.parse("https://www.feinwerkbau.de"),
                                  mode: LaunchMode.externalApplication,
                                );
                                FirebaseLog().logEvent("Partner - Feinwerkbau");
                              },
                              child: CupertinoFormRow(
                                padding: const EdgeInsets.all(10),
                                prefix: Container(),
                                helper: Center(
                                    child: Image.asset(
                                        "assets/images/partner_feinwerkbau.png",
                                        height: 40,
                                        width: 250)),
                                child: Container(),
                              ))),
                      Container(
                          color: (mode.brightness == Brightness.light)
                              ? Colors.transparent
                              : const Color(AppTheme.backgroundAdsDark),
                          child: InkWell(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                      "https://www.sauer-shootingsportswear.de"),
                                  mode: LaunchMode.externalApplication,
                                );
                                FirebaseLog().logEvent(
                                    "Partner - Sauer Shootingsportswear");
                              },
                              child: CupertinoFormRow(
                                padding: const EdgeInsets.all(10),
                                prefix: Container(),
                                helper: Center(
                                    child: Image.asset(
                                  "assets/images/partner_sauer.png",
                                  height: 40,
                                )),
                                child: Container(),
                              ))),
                      Container(
                          color: (mode.brightness == Brightness.light)
                              ? Colors.transparent
                              : const Color(AppTheme.backgroundAdsDark),
                          child: InkWell(
                              onTap: () {
                                launchUrl(
                                  Uri.parse("https://coaching-koch.de"),
                                  mode: LaunchMode.externalApplication,
                                );
                                FirebaseLog()
                                    .logEvent("Partner - Coaching Koch");
                              },
                              child: CupertinoFormRow(
                                  padding: const EdgeInsets.all(10),
                                  prefix: Container(),
                                  helper: Center(
                                    child: Center(
                                        child: Image.asset(
                                            "assets/images/partner_koch.png",
                                            height: 40)),
                                  ),
                                  child: Container()))),
                      Container(
                          color: (mode.brightness == Brightness.light)
                              ? Colors.transparent
                              : const Color(AppTheme.backgroundAdsDark),
                          child: InkWell(
                              onTap: () {
                                launchUrl(
                                  Uri.parse("https://www.disag.de"),
                                  mode: LaunchMode.externalApplication,
                                );
                                FirebaseLog().logEvent("Partner - Disag");
                              },
                              child: CupertinoFormRow(
                                padding: const EdgeInsets.all(10),
                                prefix: Container(),
                                helper: Center(
                                    child: Image.asset(
                                        "assets/images/partner_disag.png",
                                        height: 40)),
                                child: Container(),
                              ))),
                      Container(
                          color: (mode.brightness == Brightness.light)
                              ? Colors.transparent
                              : const Color(AppTheme.backgroundAdsDark),
                          child: InkWell(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                      "https://www.sauer-shootingsportswear.de/sauer-academy"),
                                  mode: LaunchMode.externalApplication,
                                );
                                FirebaseLog()
                                    .logEvent("Partner - Sauer Academy");
                              },
                              child: CupertinoFormRow(
                                padding: const EdgeInsets.all(10),
                                prefix: Container(),
                                helper: Center(
                                    child: Image.asset(
                                        "assets/images/partner_sauer_academy.png",
                                        height: 40)),
                                child: Container(),
                              ))),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                      backgroundColor: Colors.transparent,
                      decoration: const BoxDecoration(),
                      header: Text(tr("partner_action_title"),
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
                          },
                          child: Text(tr("partner_action_contact")),
                        ),
                      ]),
                ],
              ),
            )));
  }
}
