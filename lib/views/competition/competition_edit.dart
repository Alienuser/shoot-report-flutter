import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/competition_dao.dart';
import 'package:shoot_report/utilities/csv_converter.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/utilities/kind_list.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:status_alert/status_alert.dart';

class CompetitionEditWidget extends StatefulWidget {
  final Weapon weapon;
  final CompetitionDao competitionDao;
  final Competition competition;

  const CompetitionEditWidget(
      {super.key,
      required this.weapon,
      required this.competitionDao,
      required this.competition});

  @override
  State<CompetitionEditWidget> createState() => _CompetitionEditWidgetState();
}

class _CompetitionEditWidgetState extends State<CompetitionEditWidget> {
  static final _formKey = GlobalKey<FormState>();
  final _textDateController = TextEditingController();
  late String imagePath = widget.competition.image;
  late DateTime date = widget.competition.date;
  late String place = widget.competition.place;
  late String kind = widget.competition.kind;
  late int shotCount = widget.competition.shotCount;
  late List shots = widget.competition.shots;
  late String comment = widget.competition.comment;
  bool isInEditMode = false;
  int? kindValue = 0;
  num pointsTotal = 0;

  @override
  void initState() {
    _calculateTotalAndAverage();
    _textDateController.text = DateFormat.yMd().format(date);
    if (imagePath != "") {
      _setImage();
    }
    FirebaseLog().logScreenView("competition_edit.dart", "competition_edit");
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
                  tr("competition_edit_title"),
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
                            header: Text(tr("competition_general")),
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(left: 10, right: 10)),
                                value: kind,
                                onChanged: isInEditMode
                                    ? (String? value) {
                                        setState(() {
                                          kind = value!;
                                        });
                                      }
                                    : null,
                                items: KindList.competitionItems
                                    .map((String items) {
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
                                      labelText: tr("competition_date")),
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
                                        return Text(
                                            tr("competition_image_error"));
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
                                      child:
                                          Text(tr("competition_photo_delete")),
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
                                          builder: (context) {
                                            return Material(
                                                child: SafeArea(
                                              top: false,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                      title: Text(tr(
                                                          "competition_image_camera")),
                                                      leading: const Icon(Icons
                                                          .camera_alt_outlined),
                                                      onTap: () =>
                                                          _getImageFromCamera()),
                                                  ListTile(
                                                      title: Text(tr(
                                                          "competition_image_gallery")),
                                                      leading: const Icon(
                                                          Icons.image),
                                                      onTap: () =>
                                                          _getImageFromGallery())
                                                ],
                                              ),
                                            ));
                                          },
                                        );
                                      }
                                    : null,
                                child: Text(tr("competition_photo")),
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
                                            return AlertDialog.adaptive(
                                              title: Text(
                                                  tr("competition_qr_title")),
                                              content: Text(tr(
                                                  "competition_qr_description")),
                                              actions: <Widget>[
                                                TextButton(
                                                    child: Text(tr(
                                                        "competition_qr_button")),
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
                                child: Text(tr("competition_qrcode")),
                              ),
                            ]),
                        CupertinoFormSection.insetGrouped(
                          header: Text(tr("competition_result")),
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("competition_shots")),
                              enabled: isInEditMode,
                              initialValue: shotCount.toString(),
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
                                    labelText: tr("competition_serie",
                                        args: [(i + 1).toString()])),
                                enabled: isInEditMode,
                                initialValue: (i < shots.length &&
                                        shots[i] != -1 &&
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
                            header: Text(tr("training_report")),
                            children: [
                              CupertinoTextFormFieldRow(
                                  initialValue: comment,
                                  textInputAction: TextInputAction.newline,
                                  padding: const EdgeInsets.all(8),
                                  placeholder: tr("competition_comment"),
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
                                        _editCompetition();
                                      }
                                    : null,
                                child: Text(tr("competition_edit")),
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
                                child: Text(tr("competition_share")),
                              ),
                            ]),
                      ])))),
        ));
  }

  void _editCompetition() {
    widget.competition.date = date;
    if (Platform.isIOS) {
      widget.competition.image = imagePath.split("/").last;
    } else {
      widget.competition.image = imagePath;
    }
    widget.competition.place = place;
    widget.competition.kind = kind;
    widget.competition.shotCount = shotCount;
    widget.competition.shots = shots;
    widget.competition.comment = comment;
    widget.competitionDao.updateCompetition(widget.competition);

    StatusAlert.show(
      context,
      duration: const Duration(seconds: 2),
      title: tr("competition_edit_alert_title"),
      subtitle: tr("competition_edit_alert_message"),
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
    });
  }

  Future<void> _shareAsCsv() async {
    FirebaseLog().logEvent("Share Competition");
    Share.shareXFiles([
      XFile(await CsvConverter.generateCompetitionCsv(
          widget.weapon, widget.competition))
    ], text: tr("competition_share_text"));
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

  void _setImage() async {
    String directory = (await getApplicationDocumentsDirectory()).parent.path;

    setState(() {
      if (Platform.isIOS) {
        imagePath = "$directory/Documents/$imagePath";
      }
    });
  }
}
