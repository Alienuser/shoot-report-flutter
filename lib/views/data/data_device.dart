import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoot_report/utilities/theme.dart';

class DataDeviceWidget extends StatefulWidget {
  const DataDeviceWidget({Key? key}) : super(key: key);

  @override
  State<DataDeviceWidget> createState() => _DataDeviceWidgetState();
}

class _DataDeviceWidgetState extends State<DataDeviceWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textDataDeviceController =
      TextEditingController();

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
                          header: Text(tr("data_device_title"),
                              style: const TextStyle(
                                color: Color(AppTheme.accentColor),
                              )),
                          children: [
                            TextFormField(
                              controller: _textDataDeviceController,
                              maxLines: 20,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: tr("data_device_value")),
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("data_device", value);
                              },
                            ),
                          ]),
                    ])))));
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _textDataDeviceController.text = prefs.getString("data_device") ?? "";
    });
  }
}
