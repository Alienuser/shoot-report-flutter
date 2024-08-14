import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shoot_report/utilities/theme.dart';

class DataPersonWidget extends StatefulWidget {
  const DataPersonWidget({super.key});

  @override
  State<DataPersonWidget> createState() => _DataPersonWidgetState();
}

class _DataPersonWidgetState extends State<DataPersonWidget> {
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance
      .ref("${FirebaseAuth.instance.currentUser?.uid}/user");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textDataPersonNameController =
      TextEditingController();
  final TextEditingController _textDataPersonAgeController =
      TextEditingController();
  final TextEditingController _textDataPersonHightController =
      TextEditingController();
  final TextEditingController _textDataPersonClub1Controller =
      TextEditingController();
  final TextEditingController _textDataPersonClub2Controller =
      TextEditingController();
  final TextEditingController _textDataPersonTrainerontroller =
      TextEditingController();
  final TextEditingController _textDataPersonTrainerMailController =
      TextEditingController();
  final TextEditingController _textDataPersonSquadTrainerController =
      TextEditingController();
  final TextEditingController _textDataPersonSquadTrainerMailController =
      TextEditingController();
  String? imagePath;

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
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: CupertinoFormSection.insetGrouped(
                              backgroundColor: Colors.transparent,
                              decoration: const BoxDecoration(
                                  color: Colors.transparent),
                              children: [
                                imagePath != null && imagePath!.isNotEmpty
                                    ? SizedBox(
                                        child: Image.file(File(imagePath!),
                                            fit: BoxFit.contain, errorBuilder:
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                          return Text(
                                              tr("data_person_image_error"));
                                        }),
                                      )
                                    : const SizedBox.shrink(),
                                imagePath != null && imagePath!.isNotEmpty
                                    ? ElevatedButton(
                                        onPressed: () {
                                          _deleteImage();
                                        },
                                        child: Text(
                                            tr("data_person_photo_delete")),
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
                                        expand: false,
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
                                                        "data_person_image_camera")),
                                                    leading: const Icon(Icons
                                                        .camera_alt_outlined),
                                                    onTap: () =>
                                                        _getImageFromCamera()),
                                                ListTile(
                                                    title: Text(tr(
                                                        "data_person_image_gallery")),
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
                                    child: Text(tr("data_person_photo"))),
                              ])),
                      CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("data_person_title"),
                              style: const TextStyle(
                                  color: Color(AppTheme.accentColor),
                                  fontSize: 15)),
                          children: [
                            TextFormField(
                              controller: _textDataPersonNameController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("data_person_name")),
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "name": value,
                                });
                              },
                            ),
                            TextFormField(
                              controller: _textDataPersonAgeController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("data_person_age")),
                              keyboardType: TextInputType.number,
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "age": value,
                                });
                              },
                            ),
                            TextFormField(
                              controller: _textDataPersonHightController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("data_person_height")),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "height": value,
                                });
                              },
                            ),
                          ]),
                      CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("data_person_club"),
                              style: const TextStyle(
                                  color: Color(AppTheme.accentColor),
                                  fontSize: 15)),
                          children: [
                            TextFormField(
                              controller: _textDataPersonClub1Controller,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("data_person_club_1")),
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "club_1": value,
                                });
                              },
                            ),
                            TextFormField(
                              controller: _textDataPersonClub2Controller,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("data_person_club_2")),
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "club_2": value,
                                });
                              },
                            ),
                          ]),
                      CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("data_person_trainer"),
                              style: const TextStyle(
                                  color: Color(AppTheme.accentColor),
                                  fontSize: 15)),
                          children: [
                            TextFormField(
                              controller: _textDataPersonTrainerontroller,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("data_person_trainer")),
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "trainer": value,
                                });
                              },
                            ),
                            TextFormField(
                              controller: _textDataPersonTrainerMailController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("data_person_trainer_mail")),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "trainer_mail": value,
                                });
                              },
                            ),
                            TextFormField(
                              controller: _textDataPersonSquadTrainerController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText: tr("data_person_squadtrainer")),
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "squadtrainer": value,
                                });
                              },
                            ),
                            TextFormField(
                              controller:
                                  _textDataPersonSquadTrainerMailController,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  labelText:
                                      tr("data_person_squadtrainer_mail")),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "squadtrainer_mail": value,
                                });
                              },
                            ),
                          ]),
                    ])))));
  }

  Future _getImageFromCamera() async {
    Navigator.of(context).pop(null);
    ImagePickers.openCamera().then((Media? media) async {
      if (media != null) {
        if (Platform.isIOS) {
          await firebaseDatabase.update({
            "photo": media.path!.split("/").last,
          });
        } else if (Platform.isAndroid) {
          await firebaseDatabase.update({
            "photo": media.path!,
          });
        }
        setState(() {
          imagePath = media.path;
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
        .then((List medias) async {
      if (Platform.isIOS) {
        await firebaseDatabase.update({
          "photo": medias.first.path!.split("/").last,
        });
      } else if (Platform.isAndroid) {
        await firebaseDatabase.update({
          "photo": medias.first.path,
        });
      }
      setState(() {
        imagePath = medias.first.path;
      });
    });
  }

  void _deleteImage() async {
    await firebaseDatabase.update({
      "photo": "",
    });
    setState(() {
      imagePath = "";
    });
  }

  void _loadData() async {
    String directory = (await getApplicationDocumentsDirectory()).parent.path;

    firebaseDatabase.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        _textDataPersonNameController.text = (data as Map)['name'] ?? "";
        _textDataPersonAgeController.text = (data)['age'] ?? "";
        _textDataPersonHightController.text = (data)['height'] ?? "";
        _textDataPersonClub1Controller.text = (data)['club_1'] ?? "";
        _textDataPersonClub2Controller.text = (data)['club_2'] ?? "";
        _textDataPersonTrainerontroller.text = (data)['trainer'] ?? "";
        _textDataPersonTrainerMailController.text =
            (data)['trainer_mail'] ?? "";
        _textDataPersonSquadTrainerController.text =
            (data)['squadtrainer'] ?? "";
        _textDataPersonSquadTrainerMailController.text =
            (data)['squadtrainer_mail'] ?? "";

        // Get image path if there is one
        if ((data)['photo'] != null && (data)['photo'] != "") {
          if (Platform.isIOS) {
            imagePath = "$directory/Documents/${(data)['photo']}";
          } else if (Platform.isAndroid) {
            imagePath = (data)['photo'];
          }
        }
      });
    });
  }
}
