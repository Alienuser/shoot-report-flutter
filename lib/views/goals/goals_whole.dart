import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/theme.dart';

class GoalsWholeWidget extends StatefulWidget {
  final Weapon weapon;

  const GoalsWholeWidget({Key? key, required this.weapon}) : super(key: key);

  @override
  State<GoalsWholeWidget> createState() => _GoalsWholeWidgetState();
}

class _GoalsWholeWidgetState extends State<GoalsWholeWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textWhole40JackpotController =
      TextEditingController();
  final TextEditingController _textWhole40OptimalController =
      TextEditingController();
  final TextEditingController _textWhole40RealController =
      TextEditingController();
  final TextEditingController _textWhole40MinimalController =
      TextEditingController();
  final TextEditingController _textWhole40ChaosController =
      TextEditingController();
  final TextEditingController _textWhole60JackpotController =
      TextEditingController();
  final TextEditingController _textWhole60OptimalController =
      TextEditingController();
  final TextEditingController _textWhole60RealController =
      TextEditingController();
  final TextEditingController _textWhole60MinimalController =
      TextEditingController();
  final TextEditingController _textWhole60ChaosController =
      TextEditingController();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("goals_whole_40_title"),
                              style: const TextStyle(
                                color: Color(AppTheme.accentColor),
                              )),
                          children: [
                            TextFormField(
                              controller: _textWhole40JackpotController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_jackpot.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_jackpot")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_40_jackpot",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _textWhole40OptimalController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_optimal.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_optimal")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_40_optimal",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _textWhole40RealController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_real.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_real")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_40_real",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _textWhole40MinimalController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_minimal.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_minimal")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_40_minimal",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _textWhole40ChaosController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_chaos.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_chaos")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_40_chaos",
                                    value);
                              },
                            ),
                          ]),
                      CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("goals_whole_60_title"),
                              style: const TextStyle(
                                color: Color(AppTheme.accentColor),
                              )),
                          children: [
                            TextFormField(
                              controller: _textWhole60JackpotController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_jackpot.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_jackpot")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_60_jackpot",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _textWhole60OptimalController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_optimal.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_optimal")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_60_optimal",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _textWhole60RealController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_real.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_real")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_60_real",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _textWhole60MinimalController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_minimal.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_minimal")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_60_minimal",
                                    value);
                              },
                            ),
                            TextFormField(
                              controller: _textWhole60ChaosController,
                              textInputAction: TextInputAction.done,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("goals_whole_value"),
                                  prefixIcon: SvgPicture.asset(
                                    "assets/images/arrow_chaos.svg",
                                    height: 1,
                                    color: const Color(AppTheme.accentColor),
                                  ),
                                  labelText: tr("goals_whole_chaos")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    widget.weapon.prefFile +
                                        "_goalWhole_60_chaos",
                                    value);
                              },
                            ),
                          ]),
                    ])))));
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _textWhole40JackpotController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_40_jackpot") ??
              "";
      _textWhole40OptimalController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_40_optimal") ??
              "";
      _textWhole40RealController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_40_real") ?? "";
      _textWhole40MinimalController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_40_minimal") ??
              "";
      _textWhole40ChaosController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_40_chaos") ?? "";
      _textWhole60JackpotController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_60_jackpot") ??
              "";
      _textWhole60OptimalController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_60_optimal") ??
              "";
      _textWhole60RealController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_60_real") ?? "";
      _textWhole60MinimalController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_60_minimal") ??
              "";
      _textWhole60ChaosController.text =
          prefs.getString(widget.weapon.prefFile + "_goalWhole_60_chaos") ?? "";
    });
  }
}
