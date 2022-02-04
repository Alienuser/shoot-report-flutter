import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/competition.dart';

class CompetitionEditWidget extends StatelessWidget {
  final Competition competition;

  const CompetitionEditWidget({Key? key, required this.competition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            leading: Container(), title: Text(tr("competition_edit_title"))),
        body: SafeArea(
          bottom: false,
          child: ListView(
            children: const <Widget>[
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Album'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
