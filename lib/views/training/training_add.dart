import 'dart:io';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/training_dao.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/utilities/indicator_to_image.dart';
import 'package:shoot_report/utilities/kind_list.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:status_alert/status_alert.dart';

class TrainingAddWidget extends StatefulWidget {
  final Weapon weapon;
  final TrainingDao trainingDao;

  const TrainingAddWidget(
      {super.key, required this.weapon, required this.trainingDao});

  @override
  State<TrainingAddWidget> createState() => _TrainingAddWidgetState();
}

class _TrainingAddWidgetState extends State<TrainingAddWidget> {
  static final _formKey = GlobalKey<FormState>();
  final _textDateController = TextEditingController();
  late String imagePath = "";
  late DateTime date = DateTime.now();
  late int indicator = 2;
  late String place = "";
  late String kind = KindList.trainingItems[0];
  late int shotCount = -1;
  late List shots = [];
  late String comment = "";
  int? kindValue = 0;
  num pointsTotal = 0;
  String pointsAverage = "0";

  @override
  void initState() {
    _textDateController.text = DateFormat.yMd().format(date);
    FirebaseLog().logScreenView("training_add.dart", "training_add");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Material(
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  tr("training_add_title"),
                ),
                actions: <Widget>[
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
                                    setState(() {
                                      indicator = value!;
                                    });
                                  },
                                ),
                              )
                            ]),
                        CupertinoFormSection.insetGrouped(
                            header: Text(tr("training_general")),
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(left: 10, right: 10)),
                                hint: Text(tr("training_kind")),
                                onChanged: (String? value) {
                                  setState(() {
                                    kind = value!;
                                  });
                                },
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
                                      onPressed: () {
                                        setState(() {
                                          imagePath = "";
                                        });
                                      },
                                      child: Text(tr("training_photo_delete")),
                                    )
                                  : const SizedBox.shrink(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(AppTheme.primaryColor),
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: () {
                                  showMaterialModalBottomSheet(
                                    context: context,
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
                                                leading: const Icon(
                                                    Icons.camera_alt_outlined),
                                                onTap: () =>
                                                    _getImageFromCamera()),
                                            ListTile(
                                                title: Text(tr(
                                                    "training_image_gallery")),
                                                leading:
                                                    const Icon(Icons.image),
                                                onTap: () =>
                                                    _getImageFromGallery()),
                                          ],
                                        ),
                                      ));
                                    },
                                  );
                                },
                                child: Text(tr("training_photo")),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(AppTheme.primaryColor),
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog.adaptive(
                                        title: Text(tr("training_qr_title")),
                                        content:
                                            Text(tr("training_qr_description")),
                                        actions: <Widget>[
                                          TextButton(
                                              child: Text(
                                                  tr("training_qr_button")),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      );
                                    },
                                  );
                                },
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
                                  labelText: tr("training_shots")),
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
                            for (var i = 0; i < (shotCount / 10).ceil(); i++)
                              TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    labelText: tr("training_serie",
                                        args: [(i + 1).toString()])),
                                initialValue:
                                    (shots[i] != -1) ? shots[i].toString() : "",
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
                                  onChanged: (value) async {
                                    comment = value;
                                  }),
                            ]),
                        CupertinoFormSection.insetGrouped(
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
                                onPressed: () {
                                  _addTraining();
                                },
                                child: Text(tr("training_add")),
                              ),
                            ]),
                      ])))),
        ));
  }

  void _addTraining() {
    var training = Training(
        null,
        date,
        Platform.isIOS ? imagePath.split("/").last : imagePath,
        indicator,
        place,
        kind,
        shotCount,
        shots,
        comment,
        widget.weapon.id!);

    widget.trainingDao.insertTraining(training);

    StatusAlert.show(
      context,
      duration: const Duration(seconds: 2),
      title: tr("training_add_alert_title"),
      subtitle: tr("training_add_alert_message"),
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
          (previous, current) => (previous != -1 && current != -1)
              ? previous + current
              : previous);
      if (shots.isNotEmpty) {
        pointsAverage = (pointsTotal / shotCount).toStringAsFixed(2);
      }
    });
  }

  Future _getImageFromCamera() async {
    Navigator.of(context).pop(null);
    ImagePickers.openCamera().then((Media? media) {
      if (media != null) {
        setState(() {
          imagePath = media.path!;
        });
      }
    });
  }

  Future _getImageFromGallery() async {
    Navigator.of(context).pop(null);
    ImagePickers.pickerPaths(
            galleryMode: GalleryMode.image,
            selectCount: 1,
            showGif: false,
            showCamera: true,
            uiConfig:
                UIConfig(uiThemeColor: const Color(AppTheme.primaryColor)),
            cropConfig: CropConfig(enableCrop: false, width: 2, height: 1))
        .then((List medias) {
      if (medias.isNotEmpty) {
        setState(() {
          imagePath = medias.first.path;
        });
      }
    });
  }
}
