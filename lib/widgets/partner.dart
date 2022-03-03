import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerWidget extends StatefulWidget {
  const PartnerWidget({Key? key}) : super(key: key);

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
                    primary: Colors.white,
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
                                launch(
                                  "https://www.feinwerkbau.de",
                                  forceSafariVC: false,
                                  forceWebView: false,
                                );
                              },
                              child: CupertinoFormRow(
                                padding: const EdgeInsets.all(10),
                                prefix: Container(),
                                child: Container(),
                                helper: Center(
                                    child: Image.asset(
                                        "assets/images/partner_feinwerkbau.png",
                                        height: 40,
                                        width: 250)),
                              ))),
                      Container(
                          color: (mode.brightness == Brightness.light)
                              ? Colors.transparent
                              : const Color(AppTheme.backgroundAdsDark),
                          child: InkWell(
                              onTap: () {
                                launch(
                                  "https://www.sauer-shootingsportswear.de",
                                  forceSafariVC: false,
                                  forceWebView: false,
                                );
                              },
                              child: CupertinoFormRow(
                                padding: const EdgeInsets.all(10),
                                prefix: Container(),
                                child: Container(),
                                helper: Center(
                                    child: Image.asset(
                                  "assets/images/partner_sauer.png",
                                  height: 40,
                                )),
                              ))),
                      Container(
                          color: (mode.brightness == Brightness.light)
                              ? Colors.transparent
                              : const Color(AppTheme.backgroundAdsDark),
                          child: InkWell(
                              onTap: () {
                                launch(
                                  "https://coaching-koch.de",
                                  forceSafariVC: false,
                                  forceWebView: false,
                                );
                              },
                              child: CupertinoFormRow(
                                  padding: const EdgeInsets.all(10),
                                  prefix: Container(),
                                  child: Container(),
                                  helper: Center(
                                    child: Center(
                                        child: Image.asset(
                                            "assets/images/partner_koch.png",
                                            height: 40)),
                                  )))),
                      Container(
                          color: (mode.brightness == Brightness.light)
                              ? Colors.transparent
                              : const Color(AppTheme.backgroundAdsDark),
                          child: InkWell(
                              onTap: () {
                                launch(
                                  "https://www.disag.de",
                                  forceSafariVC: false,
                                  forceWebView: false,
                                );
                              },
                              child: CupertinoFormRow(
                                padding: const EdgeInsets.all(10),
                                prefix: Container(),
                                child: Container(),
                                helper: Center(
                                    child: Image.asset(
                                        "assets/images/partner_disag.png",
                                        height: 40)),
                              ))),
                      Container(
                        color: (mode.brightness == Brightness.light)
                            ? Colors.transparent
                            : const Color(AppTheme.backgroundAdsDark),
                        child: InkWell(
                            onTap: () {
                              launch(
                                "https://tec-hro.de/schiesssport",
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            },
                            child: CupertinoFormRow(
                              padding: const EdgeInsets.all(10),
                              prefix: Container(),
                              child: Container(),
                              helper: Center(
                                  child: Image.asset(
                                "assets/images/partner_techro.png",
                                height: 40,
                              )),
                            )),
                      )
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
                            primary: const Color(AppTheme.accentColor),
                          ),
                          onPressed: () {
                            launch(
                              "https://www.burkhardt-sport.solutions/kontakt",
                              forceSafariVC: false,
                              forceWebView: false,
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
