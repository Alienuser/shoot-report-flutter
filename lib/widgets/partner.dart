import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerWidget extends StatelessWidget {
  const PartnerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  child: Text(tr("general_close")),
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
                            color: Color(AppTheme.accentColor))),
                    children: [
                      InkWell(
                          onTap: () {
                            launch(
                              "https://www.feinwerkbau.de",
                              forceSafariVC: false,
                              forceWebView: false,
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CupertinoFormRow(
                                prefix: Container(),
                                child: Container(),
                                helper: SvgPicture.asset(
                                    "assets/images/partner_feinwerkbau.svg"),
                              ))),
                      InkWell(
                          onTap: () {
                            launch(
                              "https://www.sauer-shootingsportswear.de",
                              forceSafariVC: false,
                              forceWebView: false,
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CupertinoFormRow(
                                prefix: Container(),
                                child: Container(),
                                helper: SvgPicture.asset(
                                    "assets/images/partner_sauer.svg"),
                              ))),
                      InkWell(
                          onTap: () {
                            launch(
                              "https://coaching-koch.de",
                              forceSafariVC: false,
                              forceWebView: false,
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CupertinoFormRow(
                                prefix: Container(),
                                child: Container(),
                                helper: SvgPicture.asset(
                                    "assets/images/partner_koch.svg"),
                              ))),
                      InkWell(
                          onTap: () {
                            launch(
                              "https://www.disag.de",
                              forceSafariVC: false,
                              forceWebView: false,
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CupertinoFormRow(
                                prefix: Container(),
                                child: Container(),
                                helper: SvgPicture.asset(
                                    "assets/images/partner_disag.svg"),
                              ))),
                      InkWell(
                          onTap: () {
                            launch(
                              "https://tec-hro.de/schiesssport",
                              forceSafariVC: false,
                              forceWebView: false,
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CupertinoFormRow(
                                prefix: Container(),
                                child: Container(),
                                helper: SvgPicture.asset(
                                    "assets/images/partner_techro.svg"),
                              ))),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                      backgroundColor: Colors.transparent,
                      decoration: const BoxDecoration(),
                      header: Text(tr("partner_action_title")),
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color(AppTheme.accentColor),
                              minimumSize: const Size.fromHeight(40),
                              textStyle: const TextStyle(
                                fontSize: 20,
                              )),
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
