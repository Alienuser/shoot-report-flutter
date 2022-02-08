import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/theme.dart';

class GoalsTenthWidget extends StatefulWidget {
  final Weapon weapon;

  const GoalsTenthWidget({Key? key, required this.weapon}) : super(key: key);

  @override
  State<GoalsTenthWidget> createState() => _GoalsTenthWidgetState();
}

class _GoalsTenthWidgetState extends State<GoalsTenthWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _text40JackpotController =
      TextEditingController();
  final TextEditingController _text40OptimalController =
      TextEditingController();
  final TextEditingController _text40RealController = TextEditingController();
  final TextEditingController _text40MinimalController =
      TextEditingController();
  final TextEditingController _text40ChaosController = TextEditingController();
  final TextEditingController _text60JackpotController =
      TextEditingController();
  final TextEditingController _text60OptimalController =
      TextEditingController();
  final TextEditingController _text60RealController = TextEditingController();
  final TextEditingController _text60MinimalController =
      TextEditingController();
  final TextEditingController _text60ChaosController = TextEditingController();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(AppTheme.infoBackgroundColor),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      CupertinoFormSection.insetGrouped(
                          header: Text(tr("goals_tenth_40_title"),
                              style: const TextStyle(
                                color: Color(AppTheme.accentColor),
                              )),
                          children: [
                            TextFormField(
                              controller: _text40JackpotController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_jackpot.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_jackpot")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_40_jackpot",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _text40OptimalController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_optimal.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_optimal")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_40_optimal",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _text40RealController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_real.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_real")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_40_real",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _text40MinimalController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_minimal.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_minimal")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_40_minimal",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _text40ChaosController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_chaos.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_chaos")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_40_chaos",
                                    value);
                              },
                            ),
                          ]),
                      CupertinoFormSection.insetGrouped(
                          header: Text(tr("goals_whole_60_title"),
                              style: const TextStyle(
                                color: Color(AppTheme.accentColor),
                              )),
                          children: [
                            TextFormField(
                              controller: _text60JackpotController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_jackpot.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_jackpot")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_60_jackpot",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _text60OptimalController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_optimal.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_optimal")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_60_optimal",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _text60RealController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_real.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_real")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_60_real",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _text60MinimalController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_minimal.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_minimal")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_60_minimal",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _text60ChaosController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_tenth_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_chaos.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_tenth_chaos")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalTenth_60_chaos",
                                    value);
                              },
                            ),
                          ]),
                    ])))));
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _text40JackpotController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_40_jackpot") ??
              "";
      _text40OptimalController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_40_optimal") ??
              "";
      _text40RealController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_40_real") ?? "";
      _text40MinimalController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_40_minimal") ??
              "";
      _text40ChaosController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_40_chaos") ?? "";
      _text60JackpotController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_60_jackpot") ??
              "";
      _text60OptimalController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_60_optimal") ??
              "";
      _text60RealController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_60_real") ?? "";
      _text60MinimalController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_60_minimal") ??
              "";
      _text60ChaosController.text =
          prefs.getString(widget.weapon.prefFile + "_goalTenth_60_chaos") ?? "";
    });
  }
}
