import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/theme.dart';

class ProcedurePreparationWidget extends StatefulWidget {
  final Weapon weapon;

  const ProcedurePreparationWidget({Key? key, required this.weapon})
      : super(key: key);

  @override
  State<ProcedurePreparationWidget> createState() =>
      _ProcedurePreparationWidgetState();
}

class _ProcedurePreparationWidgetState
    extends State<ProcedurePreparationWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textPreparationController =
      TextEditingController();

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
                          header: Text(tr("procedure_preparation_title"),
                              style: const TextStyle(
                                color: Color(CompanyColors.accentColor),
                              )),
                          children: [
                            TextFormField(
                              controller: _textPreparationController,
                              maxLines: 20,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(10.0),
                                hintText: tr("procedure_preparation_text"),
                              ),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_procedure_before",
                                    value);
                              },
                            ),
                          ]),
                    ])))));
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _textPreparationController.text =
          prefs.getString(widget.weapon.prefFile + "_procedure_before") ?? "";
    });
  }
}
