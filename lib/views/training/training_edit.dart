import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/utilities/csv_converter.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/utilities/indicator_to_image.dart';
import 'package:shoot_report/utilities/kind_list.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:status_alert/status_alert.dart';

class TrainingEditWidget extends StatefulWidget {
  final Weapon weapon;
  final TrainingDao trainingDao;
  final Training training;

  const TrainingEditWidget(
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
  final _textDateController = TextEditingController();
  late String imagePath = widget.training.image;
  late DateTime date = widget.training.date;
  late int indicator = widget.training.indicator;
  late String place = widget.training.place;
  late String kind = widget.training.kind;
  late int shotCount = widget.training.shotCount;
  late List shots = widget.training.shots;
  late String comment = widget.training.comment;
  bool isInEditMode = false;
  int? kindValue = 0;
  num pointsTotal = 0;
  String pointsAverage = "0";

  @override
  void initState() {
    _calculateTotalAndAverage();
    _textDateController.text = DateFormat.yMd().format(date);
    if (imagePath != "") {
      _setImage();
    }
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
        child: Material(
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  tr("training_edit_title"),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () => setState(() {
                      isInEditMode = !isInEditMode;
                    }),
                    icon: const Icon(Icons.edit),
                    color: Colors.white,
                  ),
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
                  child: Form(
                      key: _formKey,
                      child: Column(children: [
                        CupertinoFormSection.insetGrouped(
                            backgroundColor: Colors.transparent,
                            header: Text(tr("training_evaluation")),
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: CupertinoSlidingSegmentedControl<int>(
                                  groupValue: indicator,
                                  backgroundColor: (mode.brightness ==
                                          Brightness.light)
                                      ? const Color(AppTheme.backgroundLight)
                                      : const Color(AppTheme.backgroundDark),
                                  thumbColor:
                                      const Color(AppTheme.primaryColor),
                                  children: {
                                    0: IndicatorImage.getIcon(0),
                                    1: IndicatorImage.getIcon(1),
                                    2: IndicatorImage.getIcon(2),
                                    3: IndicatorImage.getIcon(3),
                                  },
                                  onValueChanged: (value) {
                                    if (isInEditMode) {
                                      setState(() {
                                        indicator = value!;
                                      });
                                    }
                                  },
                                ),
                              )
                            ]),
                        CupertinoFormSection.insetGrouped(
                            backgroundColor: Colors.transparent,
                            header: Text(tr("training_general")),
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(left: 10, right: 10)),
                                value: kind,
                                isDense: true,
                                onChanged: isInEditMode
                                    ? (String? value) {
                                        setState(() {
                                          kind = value!;
                                        });
                                      }
                                    : null,
                                items:
                                    KindList.trainingItems.map((String items) {
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
                                    labelText: tr("training_location")),
                                enabled: isInEditMode,
                                textInputAction: TextInputAction.next,
                                initialValue: place,
                                onChanged: (value) async {
                                  place = value;
                                },
                              ),
                              TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.all(10.0),
                                      labelText: tr("training_date")),
                                  enabled: isInEditMode,
                                  controller: _textDateController,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: date,
                                      firstDate: DateTime(1960),
                                      lastDate: DateTime(2500),
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
                                        return Text(tr("training_image_error"));
                                      }),
                                    )
                                  : const SizedBox.shrink(),
                              imagePath != ""
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(AppTheme.primaryColor),
                                        minimumSize: const Size.fromHeight(40),
                                      ),
                                      onPressed: isInEditMode
                                          ? () {
                                              setState(() {
                                                imagePath = "";
                                              });
                                            }
                                          : null,
                                      child: Text(tr("training_photo_delete")),
                                    )
                                  : const SizedBox.shrink(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(AppTheme.primaryColor),
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: isInEditMode
                                    ? () {
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
                                                      title: Text(tr(
                                                          "training_image_camera")),
                                                      leading: const Icon(Icons
                                                          .camera_alt_outlined),
                                                      onTap: () =>
                                                          _getImageFromCamera()),
                                                  ListTile(
                                                      title: Text(tr(
                                                          "training_image_gallery")),
                                                      leading: const Icon(
                                                          Icons.image),
                                                      onTap: () =>
                                                          _getImageFromGallery()),
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
                                  backgroundColor:
                                      const Color(AppTheme.primaryColor),
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: isInEditMode
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text(tr("training_qr_title")),
                                              content: Text(tr(
                                                  "training_qr_description")),
                                              actions: <Widget>[
                                                TextButton(
                                                    child: Text(tr(
                                                        "training_qr_button")),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    : null,
                                child: Text(tr("training_qrcode")),
                              ),
                            ]),
                        CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("training_result")),
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("training_shots")),
                              enabled: isInEditMode,
                              initialValue:
                                  (shotCount == -1) ? "" : shotCount.toString(),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) async {
                                shotCount = int.tryParse(value) ?? 0;
                                shots =
                                    List.filled((shotCount / 10).ceil(), -1);
                                _calculateTotalAndAverage();
                              },
                            ),
                            for (var i = 0;
                                i < (shotCount / 10).ceil() && i < shots.length;
                                i++)
                              TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    labelText: tr("training_serie",
                                        args: [(i + 1).toString()])),
                                enabled: isInEditMode,
                                initialValue: (shots[i] != -1 &&
                                        shots[i].toString() != "null")
                                    ? shots[i].toString()
                                    : "",
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                textInputAction: TextInputAction.next,
                                onChanged: (value) async {
                                  if (value.isNotEmpty) {
                                    if (value.contains(",") ||
                                        value.contains(".")) {
                                      shots[i] = double.tryParse(
                                              value.replaceAll(",", ".")) ??
                                          0;
                                    } else {
                                      shots[i] = int.tryParse(value);
                                    }
                                  } else {
                                    shots[i] = 0;
                                  }
                                  _calculateTotalAndAverage();
                                },
                              ),
                          ],
                        ),
                        CupertinoFormSection.insetGrouped(
                            backgroundColor: Colors.transparent,
                            header: Text(tr("training_score")),
                            children: [
                              ListTile(
                                title: Text(tr("training_rings_total")),
                                trailing:
                                    (shots.any((element) => element is double))
                                        ? Text(pointsTotal.toStringAsFixed(1))
                                        : Text(pointsTotal.toString()),
                              ),
                              ListTile(
                                title: Text(tr("training_rings_average")),
                                trailing: Text(pointsAverage),
                              ),
                            ]),
                        CupertinoFormSection.insetGrouped(
                            backgroundColor: Colors.transparent,
                            header: Text(tr("training_report")),
                            children: [
                              CupertinoTextFormFieldRow(
                                  initialValue: comment,
                                  textInputAction: TextInputAction.newline,
                                  padding: const EdgeInsets.all(8),
                                  placeholder: tr("training_comment"),
                                  maxLines: 10,
                                  style: TextStyle(
                                    color: (mode.brightness == Brightness.light)
                                        ? const Color(AppTheme.textColorLight)
                                        : const Color(AppTheme.textColorDark),
                                  ),
                                  enabled: isInEditMode,
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
                                  backgroundColor:
                                      const Color(AppTheme.primaryColor),
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: isInEditMode
                                    ? () {
                                        _editTraining();
                                      }
                                    : null,
                                child: Text(tr("training_edit")),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(AppTheme.primaryColor),
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: !isInEditMode
                                    ? () {
                                        _shareAsCsv();
                                      }
                                    : null,
                                child: Text(tr("training_share")),
                              ),
                            ]),
                      ])))),
        ));
  }

  void _editTraining() {
    widget.training.date = date;
    if (Platform.isIOS) {
      widget.training.image = imagePath.split("/").last;
    } else {
      widget.training.image = imagePath;
    }
    widget.training.indicator = indicator;
    widget.training.place = place;
    widget.training.kind = kind;
    widget.training.shotCount = shotCount;
    widget.training.shots = shots;
    widget.training.comment = comment;
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
    HapticFeedback.heavyImpact();
    Navigator.of(context).pop(null);
  }

  void _calculateTotalAndAverage() {
    setState(() {
      pointsTotal = shots.fold(
          0,
          (previous, current) =>
              (previous != -1 && current != -1 && current != null)
                  ? previous + current
                  : previous);
      if (shots.isNotEmpty) {
        pointsAverage = (pointsTotal / shotCount).toStringAsFixed(2);
      }
    });
  }

  Future<void> _shareAsCsv() async {
    FirebaseLog().logEvent("Share Training");
    Share.shareXFiles([
      XFile(await CsvConverter.generateTrainingCsv(
          widget.weapon, widget.training))
    ], text: tr("training_share_text"));
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

  void _setImage() async {
    String directory = (await getApplicationDocumentsDirectory()).parent.path;
    setState(() {
      if (Platform.isIOS) {
        imagePath = "$directory/tmp/$imagePath";
      }
    });
  }
}
