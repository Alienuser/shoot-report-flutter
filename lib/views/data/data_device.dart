import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';

class DataDeviceWidget extends StatefulWidget {
  const DataDeviceWidget({super.key});

  @override
  State<DataDeviceWidget> createState() => _DataDeviceWidgetState();
}

class _DataDeviceWidgetState extends State<DataDeviceWidget> {
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance
      .ref("${FirebaseAuth.instance.currentUser?.uid}/device");
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
          FocusManager.instance.primaryFocus?.unfocus();
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
                                  fontSize: 15)),
                          children: [
                            CupertinoTextFormFieldRow(
                              controller: _textDataDeviceController,
                              textInputAction: TextInputAction.newline,
                              placeholder: tr("data_device_value"),
                              padding: const EdgeInsets.all(8),
                              maxLines: 20,
                              style: TextStyle(
                                color: (mode.brightness == Brightness.light)
                                    ? const Color(AppTheme.textColorLight)
                                    : const Color(AppTheme.textColorDark),
                              ),
                              onChanged: (value) async {
                                await firebaseDatabase.update({
                                  "data": value,
                                });
                              },
                            ),
                          ]),
                    ])))));
  }

  void _loadData() async {
    firebaseDatabase.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        _textDataDeviceController.text = (data as Map)['data'] ?? "";
      });
    });
  }
}
