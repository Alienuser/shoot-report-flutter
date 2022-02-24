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
    final ThemeData mode = Theme.of(context);
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      CupertinoFormSection.insetGrouped(
                          backgroundColor: Colors.transparent,
                          header: Text(tr("data_device_title"),
                              style: const TextStyle(
                                color: Color(AppTheme.accentColor),
                                //fontWeight: FontWeight.bold)
                              )),
                          children: [
                            CupertinoTextFormFieldRow(
                              controller: _textDataDeviceController,
                              textInputAction: TextInputAction.done,
                              placeholder: tr("general_value"),
                              padding: const EdgeInsets.all(8),
                              maxLines: 20,
                              style: TextStyle(
                                color: (mode.brightness == Brightness.light)
                                    ? const Color(AppTheme.textColorLight)
                                    : const Color(AppTheme.textColorDark),
                              ),
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
