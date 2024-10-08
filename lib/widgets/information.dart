import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationWidget extends StatefulWidget {
  const InformationWidget({super.key});

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
    FirebaseLog().logScreenView("information.dart", "information");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return Material(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                tr("information_title"),
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
                    header: Text(tr("information_author_title"),
                        style: const TextStyle(
                            color: Color(AppTheme.accentColor), fontSize: 15)),
                    children: [
                      CupertinoFormRow(
                        prefix: Text(tr("information_author_author"),
                            style: TextStyle(
                                color: (mode.brightness == Brightness.light)
                                    ? const Color(AppTheme.lightTextColor)
                                    : const Color(AppTheme.darkTextColor))),
                        helper: Text(tr("information_author_description"),
                            style: const TextStyle(
                                color: Color(AppTheme.textSublineColor))),
                        child: Container(),
                      ),
                      CupertinoFormRow(
                          prefix: Text(tr("information_author_website"),
                              style: TextStyle(
                                  color: (mode.brightness == Brightness.light)
                                      ? const Color(AppTheme.lightTextColor)
                                      : const Color(AppTheme.darkTextColor))),
                          helper: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              launchUrl(
                                Uri.parse(
                                    "https://${tr('information_author_website_description')}"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text(
                                tr("information_author_website_description"),
                                style: const TextStyle(color: Colors.blue)),
                          ),
                          child: Container()),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: Colors.transparent,
                    header: Text(tr("information_version_title"),
                        style: const TextStyle(
                            color: Color(AppTheme.accentColor), fontSize: 15)),
                    children: [
                      CupertinoFormRow(
                        prefix: Text(tr("information_version_version"),
                            style: TextStyle(
                                color: (mode.brightness == Brightness.light)
                                    ? const Color(AppTheme.lightTextColor)
                                    : const Color(AppTheme.darkTextColor))),
                        helper: Text(_packageInfo.version,
                            style: const TextStyle(
                                color: Color(AppTheme.textSublineColor))),
                        child: Container(),
                      ),
                      CupertinoFormRow(
                        prefix: Text(tr("information_version_build"),
                            style: TextStyle(
                                color: (mode.brightness == Brightness.light)
                                    ? const Color(AppTheme.lightTextColor)
                                    : const Color(AppTheme.darkTextColor))),
                        helper: Text(_packageInfo.buildNumber,
                            style: const TextStyle(
                                color: Color(AppTheme.textSublineColor))),
                        child: Container(),
                      ),
                      CupertinoFormRow(
                        prefix: Text(tr("information_version_date"),
                            style: TextStyle(
                                color: (mode.brightness == Brightness.light)
                                    ? const Color(AppTheme.lightTextColor)
                                    : const Color(AppTheme.darkTextColor))),
                        helper: Text(tr("information_version_date_description"),
                            style: const TextStyle(
                                color: Color(AppTheme.textSublineColor))),
                        child: Container(),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: Colors.transparent,
                    header: Text(tr("information_source_title"),
                        style: const TextStyle(
                            color: Color(AppTheme.accentColor), fontSize: 15)),
                    children: [
                      Padding(
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
