import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/firebase_data_service.dart';
import 'package:shoot_report/utilities/theme.dart';

class GoalsTenthWidget extends StatefulWidget {
  final Weapon weapon;

  const GoalsTenthWidget({super.key, required this.weapon});

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
                          header: Text(tr("goals_tenth_40_title"),
                              style: const TextStyle(
                                  color: Color(AppTheme.accentColor),
                                  fontSize: 15)),
                          children: [
                            TextFormField(
                                controller: _text40JackpotController,
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_jackpot.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_jackpot")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_40_jackpot",
                                      value);
                                }),
                            TextFormField(
                                controller: _text40OptimalController,
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_optimal.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_optimal")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_40_optimal",
                                      value);
                                }),
                            TextFormField(
                                controller: _text40RealController,
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_real.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_real")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_40_real",
                                      value);
                                }),
                            TextFormField(
                                controller: _text40MinimalController,
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_minimal.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_minimal")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_40_minimal",
                                      value);
                                }),
                            TextFormField(
                                controller: _text40ChaosController,
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_chaos.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_chaos")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_40_chaos",
                                      value);
                                })
                          ]),
                      CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("goals_whole_60_title"),
                              style: const TextStyle(
                                  color: Color(AppTheme.accentColor),
                                  fontSize: 15)),
                          children: [
                            TextFormField(
                                controller: _text60JackpotController,
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_jackpot.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_jackpot")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_60_jackpot",
                                      value);
                                }),
                            TextFormField(
                                controller: _text60OptimalController,
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_optimal.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_optimal")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_60_optimal",
                                      value);
                                }),
                            TextFormField(
                                controller: _text60RealController,
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_real.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_real")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_60_real",
                                      value);
                                }),
                            TextFormField(
                                controller: _text60MinimalController,
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_minimal.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_minimal")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_60_minimal",
                                      value);
                                }),
                            TextFormField(
                                controller: _text60ChaosController,
                                textInputAction: TextInputAction.done,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    prefixIcon: Image.asset(
                                      "assets/images/arrow_chaos.png",
                                      height: 1,
                                      color: const Color(AppTheme.accentColor),
                                    ),
                                    labelText: tr("goals_tenth_chaos")),
                                onChanged: (value) async {
                                  await FirebaseDataService.setPreference(
                                      "${widget.weapon.prefFile}_goalTenth_60_chaos",
                                      value);
                                })
                          ])
                    ])))));
  }

  void _loadData() async {
    _text40JackpotController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_40_jackpot") ?? "";
    _text40OptimalController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_40_optimal") ?? "";
    _text40RealController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_40_real") ?? "";
    _text40MinimalController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_40_minimal") ?? "";
    _text40ChaosController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_40_chaos") ?? "";
    _text60JackpotController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_60_jackpot") ?? "";
    _text60OptimalController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_60_optimal") ?? "";
    _text60RealController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_60_real") ?? "";
    _text60MinimalController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_60_minimal") ?? "";
    _text60ChaosController.text =
        await FirebaseDataService.getPreference("${widget.weapon.prefFile}_goalTenth_60_chaos") ?? "";
    setState(() {});
  }
}
