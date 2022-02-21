import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CooperationWidget extends StatelessWidget {
  const CooperationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      header: Text(tr("cooperation_list_title"),
                          style: const TextStyle(
                              color: Color(AppTheme.accentColor))),
                      children: [
                        InkWell(
                            onTap: () {
                              launch(
                                "https://www.kksvillingen.de",
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            },
                            child: CupertinoFormRow(
                              prefix: Container(),
                              child: Container(),
                              helper: Center(
                                  child: Image.asset(
                                      "assets/images/partner_kksvilligen.png",
                                      height: 70)),
                            )),
                      ]),
                  CupertinoFormSection.insetGrouped(
                      backgroundColor: Colors.transparent,
                      decoration: const BoxDecoration(),
                      header: Text(tr("cooperation_action_title")),
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
                          child: Text(tr("cooperation_action_contact")),
                        ),
                      ]),
                ],
              ),
            )));
  }
}
