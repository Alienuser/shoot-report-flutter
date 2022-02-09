import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationWidget extends StatefulWidget {
  const InformationWidget({Key? key}) : super(key: key);

  @override
  State<InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 80,
              title: Text(
                tr("information_title"),
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
                    backgroundColor: Colors.transparent,
                    header: Text(tr("information_author_title"),
                        style: const TextStyle(
                            color: Color(AppTheme.accentColor))),
                    children: [
                      CupertinoFormRow(
                        prefix: Text(tr("information_author_author")),
                        child: Container(),
                        helper: Text(tr("information_author_description"),
                            style: const TextStyle(
                                color: Color(AppTheme.lightTextColor))),
                      ),
                      CupertinoFormRow(
                          prefix: Text(tr("information_author_website")),
                          child: Container(),
                          helper: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              launch(
                                "https://${tr('information_author_website_description')}",
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            },
                            child: Text(
                                tr("information_author_website_description"),
                                style: const TextStyle(color: Colors.blue)),
                          )),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: Colors.transparent,
                    header: Text(tr("information_version_title"),
                        style: const TextStyle(
                            color: Color(AppTheme.accentColor))),
                    children: [
                      CupertinoFormRow(
                        prefix: Text(tr("information_version_version")),
                        child: Container(),
                        helper: Text(_packageInfo.version,
                            style: const TextStyle(
                                color: Color(AppTheme.lightTextColor))),
                      ),
                      CupertinoFormRow(
                        prefix: Text(tr("information_version_build")),
                        child: Container(),
                        helper: Text(_packageInfo.buildNumber,
                            style: const TextStyle(
                                color: Color(AppTheme.lightTextColor))),
                      ),
                      CupertinoFormRow(
                        prefix: Text(tr("information_version_date")),
                        child: Container(),
                        helper: Text(tr("information_version_date_description"),
                            style: const TextStyle(
                                color: Color(AppTheme.lightTextColor))),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: Colors.transparent,
                    header: Text(tr("information_source_title"),
                        style: const TextStyle(
                            color: Color(AppTheme.accentColor))),
                    children: [
                      Padding(
                          // Even Padding On All Sides
                          padding: const EdgeInsets.all(18.0),
                          child: Text(tr("information_source_description")))
                    ],
                  ),
                ],
              ),
            )));
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}
