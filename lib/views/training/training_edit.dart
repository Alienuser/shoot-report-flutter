import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/utilities/csv_converter.dart';
import 'package:shoot_report/utilities/indicator_to_image.dart';
import 'package:shoot_report/utilities/kind_list.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:status_alert/status_alert.dart';

class TrainingEditWidget extends StatefulWidget {
  final Weapon weapon;
  final TrainingDao trainingDao;
  final Training training;

  late String? imagePath = training.image;
  late DateTime date = training.date;
  late int indicator = training.indicator;
  late String place = training.place;
  late String kind = training.kind;
  late int shotCount = training.shotCount;
  late List shots = training.shots;
  late String comment = training.comment;

  TrainingEditWidget(
      {Key? key,
      required this.weapon,
      required this.trainingDao,
      required this.training})
      : super(key: key);

  @override
  State<TrainingEditWidget> createState() => _TrainingEditWidgetState();
}

class _TrainingEditWidgetState extends State<TrainingEditWidget> {
  static final _formKey = GlobalKey<FormState>();
  bool isInEditMode = false;
  int? groupValue = 0;
  num pointsTotal = 0;
  String pointsAverage = "0";

  @override
  void initState() {
    calculateTotalAndAverage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: const Color(CompanyColors.infoBackgroundColor),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          title: Text(
            tr("training_edit_title"),
            style: const TextStyle(fontSize: 25),
          ),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              onPressed: () => setState(() {
                isInEditMode = !isInEditMode;
              }),
              icon: const Icon(Icons.edit),
            ),
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
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      CupertinoFormSection.insetGrouped(
                          header: Text(tr("training_evaluation")),
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: CupertinoSlidingSegmentedControl<int>(
                                groupValue: widget.indicator,
                                backgroundColor: Colors.white,
                                thumbColor:
                                    const Color(CompanyColors.primaryColor),
                                children: {
                                  0: IndicatorImage.getIcon(0),
                                  1: IndicatorImage.getIcon(1),
                                  2: IndicatorImage.getIcon(2),
                                  3: IndicatorImage.getIcon(3),
                                },
                                onValueChanged: (value) {
                                  setState(() {
                                    widget.indicator = value!;
                                  });
                                },
                              ),
                            )
                          ]),
                      CupertinoFormSection.insetGrouped(
                          header: Text(tr("training_general")),
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DropdownButton(
                                  value: widget.kind,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  isDense: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: KindList.items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: isInEditMode
                                      ? (String? value) {
                                          setState(() {
                                            widget.kind = value!;
                                          });
                                        }
                                      : null,
                                )),
                            TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(10.0),
                                hintText: tr("training_location"),
                              ),
                              enabled: isInEditMode,
                              initialValue: widget.place,
                              onChanged: (value) async {
                                widget.place = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(10.0),
                                hintText: tr("training_date"),
                              ),
                              enabled: isInEditMode,
                              initialValue: DateFormat.yMd()
                                  .format(widget.date)
                                  .toString(),
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: widget.date,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2025),
                                );
                                if (picked != null) {
                                  widget.date = picked;
                                  setState(() {
                                    widget.date = picked;
                                  });
                                }
                              },
                            ),
                          ]),
                      CupertinoFormSection.insetGrouped(
                          decoration: const BoxDecoration(
                            color: Color(CompanyColors.infoBackgroundColor),
                          ),
                          children: [
                            widget.imagePath != null &&
                                    widget.imagePath!.isNotEmpty
                                ? SizedBox(
                                    child: Image.file(File(widget.imagePath!),
                                        fit: BoxFit.contain, errorBuilder:
                                            (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                      return Text(tr("training_image_error"));
                                    }),
                                  )
                                : const SizedBox.shrink(),
                            widget.imagePath != null &&
                                    widget.imagePath!.isNotEmpty
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(
                                          CompanyColors.primaryColor),
                                      minimumSize: const Size.fromHeight(40),
                                    ),
                                    onPressed: isInEditMode
                                        ? () {
                                            setState(() {
                                              widget.imagePath = "";
                                            });
                                          }
                                        : null,
                                    child: Text(tr("training_photo_delete")),
                                  )
                                : const SizedBox.shrink(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color(CompanyColors.primaryColor),
                                minimumSize: const Size.fromHeight(40),
                              ),
                              onPressed: isInEditMode
                                  ? () {
                                      showModalBottomSheet(
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
                                                    title: Text(tr(
                                                        "training_image_camera")),
                                                    leading: const Icon(Icons
                                                        .camera_alt_outlined),
                                                    onTap: () =>
                                                        getImageFromCamera()),
                                                ListTile(
                                                    title: Text(tr(
                                                        "training_image_gallery")),
                                                    leading:
                                                        const Icon(Icons.image),
                                                    onTap: () =>
                                                        getImageFromGallery()),
                                              ],
                                            ),
                                          ));
                                        },
                                      );
                                    }
                                  : null,
                              child: Text(tr("training_photo")),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color(CompanyColors.primaryColor),
                                minimumSize: const Size.fromHeight(40),
                              ),
                              onPressed: isInEditMode
                                  ? () {
                                      print("QR Code");
                                    }
                                  : null,
                              child: Text(tr("training_qrcode")),
                            ),
                          ]),
                      CupertinoFormSection.insetGrouped(
                        header: Text(tr("training_result")),
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(10.0),
                              hintText: tr("training_shots"),
                            ),
                            keyboardType: TextInputType.number,
                            enabled: isInEditMode,
                            initialValue: widget.shotCount.toString(),
                            onChanged: (value) async {
                              widget.shotCount = int.tryParse(value) ?? 0;
                              widget.shots = List.filled(
                                  (widget.shotCount / 10).ceil(), 0);
                              calculateTotalAndAverage();
                            },
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            children: List.generate(
                                (widget.shotCount / 10).ceil(), (index) {
                              return TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("training_serie"),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                enabled: isInEditMode,
                                initialValue: widget.shots[index].toString(),
                                onChanged: (value) async {
                                  widget.shots[index] =
                                      int.tryParse(value) ?? 0;
                                  calculateTotalAndAverage();
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                      CupertinoFormSection.insetGrouped(
                          header: Text(tr("training_score")),
                          children: [
                            ListTile(
                              title: Text(tr("training_rings_total")),
                              trailing: Text(pointsTotal.toString()),
                            ),
                            ListTile(
                              title: Text(tr("training_rings_average")),
                              trailing: Text(pointsAverage.toString()),
                            ),
                          ]),
                      CupertinoFormSection.insetGrouped(
                          header: Text(tr("trainig_report")),
                          children: [
                            TextFormField(
                              maxLines: 10,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(10.0),
                                hintText: tr("trainig_report"),
                              ),
                              enabled: isInEditMode,
                              initialValue: widget.comment,
                              onChanged: (value) async {
                                widget.comment = value;
                              },
                            ),
                          ]),
                      CupertinoFormSection.insetGrouped(
                          decoration: const BoxDecoration(
                            color: Color(CompanyColors.infoBackgroundColor),
                          ),
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color(CompanyColors.primaryColor),
                                minimumSize: const Size.fromHeight(40),
                              ),
                              onPressed: isInEditMode
                                  ? () {
                                      editTraining();
                                    }
                                  : null,
                              child: Text(tr("training_edit")),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color(CompanyColors.primaryColor),
                                minimumSize: const Size.fromHeight(40),
                              ),
                              onPressed: !isInEditMode
                                  ? () {
                                      shareAsCsv();
                                    }
                                  : null,
                              child: Text(tr("training_share")),
                            ),
                          ]),
                    ])))),
      ),
    );
  }

  void editTraining() {
    widget.training.date = widget.date;
    widget.training.image = widget.imagePath != null ? widget.imagePath! : "";
    widget.training.indicator = widget.indicator;
    widget.training.place = widget.place;
    widget.training.kind = widget.kind;
    widget.training.shotCount = widget.shotCount;
    widget.training.shots = widget.shots;
    widget.training.comment = widget.comment;
    widget.trainingDao.updateTraining(widget.training);

    StatusAlert.show(
      context,
      duration: const Duration(seconds: 2),
      title: tr("training_edit_alert_title"),
      subtitle: tr("training_edit_alert_message"),
      padding: EdgeInsets.zero,
      configuration: const FlareConfiguration('assets/animations/success.flr',
          animation: 'check', margin: EdgeInsets.zero, color: Colors.green),
    );

    Navigator.of(context).pop(null);
  }

  void calculateTotalAndAverage() {
    setState(() {
      pointsTotal =
          widget.shots.fold(0, (previous, current) => previous + current);
      pointsAverage = (pointsTotal / widget.shotCount).toStringAsFixed(2);
    });
  }

  Future<void> shareAsCsv() async {
    Share.shareFiles(
        [await CsvConverter.generateCsv(widget.weapon, widget.training)],
        text: tr("training_share_text"));
  }

  Future getImageFromCamera() async {
    Navigator.of(context).pop(null);
    List<Media>? res = await ImagesPicker.openCamera(
      pickType: PickType.image,
      quality: 0.8,
      maxSize: 800,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.custom,
        cropType: CropType.rect,
      ),
      maxTime: 15,
    );

    if (res != null) {
      setState(() {
        widget.imagePath = res[0].thumbPath;
      });
    }
  }

  Future getImageFromGallery() async {
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
        widget.imagePath = res[0].thumbPath;
      });
    }
  }
}
