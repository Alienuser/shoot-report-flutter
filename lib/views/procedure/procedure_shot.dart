import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/theme.dart';

class ProcedureShotWidget extends StatefulWidget {
  final Weapon weapon;

  const ProcedureShotWidget({Key? key, required this.weapon}) : super(key: key);

  @override
  State<ProcedureShotWidget> createState() => _ProcedureShotWidgetState();
}

class _ProcedureShotWidgetState extends State<ProcedureShotWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textShotController = TextEditingController();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(CompanyColors.infoBackgroundColor),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      CupertinoFormSection.insetGrouped(
                          header: Text(tr("procedure_shot_title"),
                              style: const TextStyle(
                                color: Color(CompanyColors.accentColor),
                              )),
                          children: [
                            TextFormField(
                              controller: _textShotController,
                              maxLines: 20,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(10.0),
                                hintText: tr("procedure_shot_text"),
                              ),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile + "_procedure_shot",
                                    value);
                              },
                            ),
                          ]),
                    ])))));
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _textShotController.text =
          prefs.getString(widget.weapon.prefFile + "_procedure_shot") ?? "";
    });
  }
}
