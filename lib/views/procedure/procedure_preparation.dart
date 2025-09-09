import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/firebase_data_service.dart';
import 'package:shoot_report/utilities/theme.dart';

class ProcedurePreparationWidget extends StatefulWidget {
  final Weapon weapon;

  const ProcedurePreparationWidget({super.key, required this.weapon});

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
    final ThemeData mode = Theme.of(context);
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("procedure_preparation_title"),
                              style: const TextStyle(
                                  color: Color(AppTheme.accentColor),
                                  fontSize: 15)),
                          children: [
                            CupertinoTextFormFieldRow(
                                controller: _textPreparationController,
                                textInputAction: TextInputAction.newline,
                                placeholder: tr("procedure_preparation_value"),
                                padding: const EdgeInsets.all(8),
                                maxLines: 20,
                                style: TextStyle(
                                  color: (mode.brightness == Brightness.light)
                                      ? const Color(AppTheme.textColorLight)
                                      : const Color(AppTheme.textColorDark),
                                ),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_procedure_before",
                                      value);
                                })
                          ])
                    ])))));
  }

  void _loadData() async {
    _textPreparationController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_procedure_before") ?? "";
    setState(() {});
  }
}
