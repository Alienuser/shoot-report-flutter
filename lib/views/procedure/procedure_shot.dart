import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final ThemeData mode = Theme.of(context);
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("procedure_shot_title"),
                              style: const TextStyle(
                                  color: Color(AppTheme.accentColor),
                                  fontSize: 15)),
                          children: [
                            CupertinoTextFormFieldRow(
                              controller: _textShotController,
                              textInputAction: TextInputAction.done,
                              placeholder: tr("procedure_shot_value"),
                              padding: const EdgeInsets.all(8),
                              maxLines: 20,
                              style: TextStyle(
                                color: (mode.brightness == Brightness.light)
                                    ? const Color(AppTheme.textColorLight)
                                    : const Color(AppTheme.textColorDark),
                              ),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    "${widget.weapon.prefFile}_procedure_shot",
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
          prefs.getString("${widget.weapon.prefFile}_procedure_shot") ?? "";
    });
  }
}
