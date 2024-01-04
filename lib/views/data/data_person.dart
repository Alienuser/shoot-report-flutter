import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/utilities/theme.dart';

class DataPersonWidget extends StatefulWidget {
  const DataPersonWidget({super.key});

  @override
  State<DataPersonWidget> createState() => _DataPersonWidgetState();
}

class _DataPersonWidgetState extends State<DataPersonWidget> {
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("data_person_name", value);
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("data_person_age", value);
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("data_person_height", value);
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("data_person_club_1", value);
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("data_person_club_2", value);
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("data_person_trainer", value);
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    "data_person_trainer_mail", value);
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    "data_person_squadtrainer", value);
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    "data_person_squadtrainer_mail", value);
                              },
                            ),
                          ]),
                    ])))));
  }

  Future _getImageFromCamera() async {
    Navigator.of(context).pop(null);
    Media? res = await ImagePickers.openCamera();

    if (res != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (Platform.isIOS) {
        prefs.setString("data_person_photo", res.path!.split("/").last);
      } else if (Platform.isAndroid) {
        prefs.setString("data_person_photo", res.path!);
      }

      await ImagePickers.saveImageToGallery(res.path!);
      setState(() {
        imagePath = res.path!;
      });
    }
  }

  Future _getImageFromGallery() async {
    Navigator.of(context).pop(null);
    List<Media>? res = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.image,
      selectCount: 1,
      showGif: false,
      showCamera: true,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (Platform.isIOS) {
      prefs.setString("data_person_photo", res[0].path!.split("/").last);
    } else if (Platform.isAndroid) {
      prefs.setString("data_person_photo", res[0].path!);
    }

    if (res.isNotEmpty) {
      setState(() {
        imagePath = res[0].path!;
      });
    }
  }

  void _deleteImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("data_person_photo");
    setState(() {
      imagePath = "";
    });
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String directory = (await getApplicationDocumentsDirectory()).parent.path;

    setState(() {
      _textDataPersonNameController.text =
          prefs.getString("data_person_name") ?? "";
      _textDataPersonAgeController.text =
          prefs.getString("data_person_age") ?? "";
      _textDataPersonHightController.text =
          prefs.getString("data_person_height") ?? "";
      _textDataPersonClub1Controller.text =
          prefs.getString("data_person_club_1") ?? "";
      _textDataPersonClub2Controller.text =
          prefs.getString("data_person_club_2") ?? "";
      _textDataPersonTrainerontroller.text =
          prefs.getString("data_person_trainer") ?? "";
      _textDataPersonTrainerMailController.text =
          prefs.getString("data_person_trainer_mail") ?? "";
      _textDataPersonSquadTrainerController.text =
          prefs.getString("data_person_squadtrainer") ?? "";
      _textDataPersonSquadTrainerMailController.text =
          prefs.getString("data_person_squadtrainer_mail") ?? "";

      // Get image path if there is one
      if (prefs.getString("data_person_photo") != null &&
          prefs.getString("data_person_photo") != "") {
        if (Platform.isIOS) {
          imagePath =
              "$directory/Documents/${prefs.getString("data_person_photo")}";
        } else if (Platform.isAndroid) {
          imagePath = prefs.getString("data_person_photo");
        }
      }
    });
  }
}
