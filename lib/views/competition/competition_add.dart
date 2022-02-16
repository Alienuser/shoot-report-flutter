import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/utilities/kind_list.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:status_alert/status_alert.dart';

class CompetitionAddWidget extends StatefulWidget {
  final Weapon weapon;
  final CompetitionDao competitionDao;

  const CompetitionAddWidget(
      {Key? key, required this.weapon, required this.competitionDao})
      : super(key: key);

  @override
  State<CompetitionAddWidget> createState() => _CompetitionAddWidgetState();
}

class _CompetitionAddWidgetState extends State<CompetitionAddWidget> {
  static final _formKey = GlobalKey<FormState>();
  final _textDateController = TextEditingController();
  late String imagePath = "";
  late DateTime date = DateTime.now();
  late String place = "";
  late String kind = KindList.competitionItems[0];
  late int shotCount = 0;
  late List shots = [];
  late String comment = "";
  int? kindValue = 0;
  num pointsTotal = 0;

  @override
  void initState() {
    _textDateController.text = DateFormat.yMd().format(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              tr("competition_add_title"),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                child: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(null),
              ),
            ],
          ),
          body: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    CupertinoFormSection.insetGrouped(
                        backgroundColor: Colors.transparent,
                        header: Text(tr("competition_general")),
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 10, right: 10)),
                            value: kind,
                            onChanged: (String? value) {
                              setState(() {
                                kind = value!;
                              });
                            },
                            items:
                                KindList.competitionItems.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(10.0),
                                labelText: tr("competition_location")),
                            textInputAction: TextInputAction.next,
                            initialValue: place,
                            onChanged: (value) async {
                              place = value;
                            },
                          ),
                          TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("competition_date")),
                              controller: _textDateController,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(1960),
                                  lastDate: DateTime(2025),
                                );

                                if (picked != null) {
                                  setState(() {
                                    date = picked;
                                    _textDateController.text =
                                        DateFormat.yMd().format(date);
                                  });
                                }
                              }),
                        ]),
                    CupertinoFormSection.insetGrouped(
                        backgroundColor: Colors.transparent,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          imagePath != ""
                              ? SizedBox(
                                  child: Image.file(File(imagePath),
                                      fit: BoxFit.contain, errorBuilder:
                                          (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                    return Text(tr("competition_image_error"));
                                  }),
                                )
                              : const SizedBox.shrink(),
                          imagePath != ""
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(AppTheme.primaryColor),
                                    minimumSize: const Size.fromHeight(40),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      imagePath = "";
                                    });
                                  },
                                  child: Text(tr("competition_photo_delete")),
                                )
                              : const SizedBox.shrink(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(AppTheme.primaryColor),
                              minimumSize: const Size.fromHeight(40),
                            ),
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return Material(
                                      child: SafeArea(
                                    top: false,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                            title: Text(
                                                tr("competition_image_camera")),
                                            leading: const Icon(
                                                Icons.camera_alt_outlined),
                                            onTap: () => _getImageFromCamera()),
                                        ListTile(
                                            title: Text(tr(
                                                "competition_image_gallery")),
                                            leading: const Icon(Icons.image),
                                            onTap: () =>
                                                _getImageFromGallery()),
                                      ],
                                    ),
                                  ));
                                },
                              );
                            },
                            child: Text(tr("competition_photo")),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(AppTheme.primaryColor),
                              minimumSize: const Size.fromHeight(40),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(tr("competition_qr_title")),
                                    content:
                                        Text(tr("competition_qr_description")),
                                    actions: <Widget>[
                                      TextButton(
                                          child:
                                              Text(tr("competition_qr_button")),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(tr("competition_qrcode")),
                          ),
                        ]),
                    CupertinoFormSection.insetGrouped(
                      backgroundColor: Colors.transparent,
                      header: Text(tr("competition_result")),
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(10.0),
                              labelText: tr("competition_shots")),
                          initialValue: shotCount.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) async {
                            shotCount = int.tryParse(value) ?? 0;
                            shots = List.filled((shotCount / 10).ceil(), -1);
                            _calculateTotalAndAverage();
                          },
                        ),
                        for (var i = 0; i < (shotCount / 10).ceil(); i++)
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(10.0),
                                labelText: tr("competition_serie",
                                    args: [(i + 1).toString()])),
                            initialValue:
                                (shots[i] != -1) ? shots[i].toString() : "",
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            textInputAction: TextInputAction.next,
                            onChanged: (value) async {
                              if (value.contains(",") || value.contains(".")) {
                                if (value.contains(",")) {
                                  shots[i] = double.tryParse(
                                      value.replaceAll(",", "."));
                                } else {
                                  shots[i] = double.tryParse(value);
                                }
                              } else {
                                shots[i] = int.tryParse(value);
                              }
                              _calculateTotalAndAverage();
                            },
                          ),
                      ],
                    ),
                    CupertinoFormSection.insetGrouped(
                        backgroundColor: Colors.transparent,
                        header: Text(tr("competition_score")),
                        children: [
                          ListTile(
                            title: Text(tr("competition_rings_total")),
                            trailing:
                                (shots.any((element) => element is double))
                                    ? Text(pointsTotal.toStringAsFixed(1))
                                    : Text(pointsTotal.toString()),
                          ),
                        ]),
                    CupertinoFormSection.insetGrouped(
                        backgroundColor: Colors.transparent,
                        header: Text(tr("competition_report")),
                        children: [
                          TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                              maxLines: 10,
                              textInputAction: TextInputAction.done,
                              initialValue: comment,
                              onChanged: (value) async {
                                comment = value;
                              }),
                        ]),
                    CupertinoFormSection.insetGrouped(
                        backgroundColor: Colors.transparent,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(AppTheme.primaryColor),
                              minimumSize: const Size.fromHeight(40),
                            ),
                            onPressed: () {
                              _addCompetition();
                            },
                            child: Text(tr("competition_add")),
                          ),
                        ]),
                  ])))),
    );
  }

  void _addCompetition() {
    var competition = Competition(
        null,
        date,
        Platform.isIOS ? imagePath.split("/").last : imagePath,
        place,
        kind,
        shotCount,
        shots,
        comment,
        widget.weapon.id!);

    widget.competitionDao.insertCompetition(competition);

    StatusAlert.show(
      context,
      duration: const Duration(seconds: 2),
      title: tr("competition_add_alert_title"),
      subtitle: tr("competition_add_alert_message"),
      padding: EdgeInsets.zero,
      configuration: const FlareConfiguration('assets/animations/success.flr',
          animation: 'check', margin: EdgeInsets.zero, color: Colors.green),
    );
    HapticFeedback.lightImpact();

    Navigator.of(context).pop(null);
  }

  void _calculateTotalAndAverage() {
    setState(() {
      pointsTotal = shots.fold(0, (previous, current) => previous + current);
    });
  }

  Future _getImageFromCamera() async {
    Navigator.of(context).pop(null);
    List<Media>? res = await ImagesPicker.openCamera(
      pickType: PickType.image,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.custom,
        cropType: CropType.rect,
      ),
    );

    if (res != null) {
      await ImagesPicker.saveImageToAlbum(File(res[0].path),
          albumName: "shoot report");
      setState(() {
        imagePath = res[0].path;
      });
    }
  }

  Future _getImageFromGallery() async {
    Navigator.of(context).pop(null);
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.custom,
        cropType: CropType.rect,
      ),
    );

    if (res != null) {
      setState(() {
        imagePath = res[0].path;
      });
    }
  }
}
