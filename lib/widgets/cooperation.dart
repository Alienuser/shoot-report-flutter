import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CooperationWidget extends StatelessWidget {
  const CooperationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: const Color(AppTheme.infoBackgroundColor),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 80,
              title: Text(
                tr("cooperation_title"),
                style: const TextStyle(fontSize: 25),
              ),
              centerTitle: false,
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
                      header: Text(tr("cooperation_list_title"),
                          style: const TextStyle(
                              color: Color(AppTheme.accentColor))),
                      children: [
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              launch(
                                "https://www.kksvillingen.de",
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
                                        "assets/images/partner_kksvilligen.svg")))),
                      ]),
                  CupertinoFormSection.insetGrouped(
                      decoration: const BoxDecoration(
                        color: Color(AppTheme.infoBackgroundColor),
                      ),
                      header: Text(tr("cooperation_action_title")),
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
                          child: Text(tr("cooperation_action_contact")),
                        ),
                      ]),
                ],
              ),
            )));
  }
}
