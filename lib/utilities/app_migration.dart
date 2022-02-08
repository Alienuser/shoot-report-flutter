import 'dart:io';
import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';

class AppMigration {
  static void doDatabaseMigration() async {
    if (Platform.isAndroid) {
      try {
        await openDatabase(
          "report.db",
          onOpen: (db) async {
            List<Map> list = await db.rawQuery('SELECT * FROM rifle_table');
            print(list);
          },
        );
      } catch (_) {}
    } else if (Platform.isIOS) {
      try {
        await openDatabase(
          "${(await getApplicationSupportDirectory()).path}/shoot_report.sqlite",
          onOpen: (db) async {
            List<Map> list = await db.rawQuery('SELECT * from ZRIFLE;');
            print(list);
          },
        );
      } catch (_) {}
    }
  }

  static void doSharedPrefMigration() async {
    if (Platform.isAndroid) {
      var path = (await getApplicationDocumentsDirectory()).parent.path +
          "/shared_prefs/preference_rifle_1.xml";
      var file = File(path);
      var document = XmlDocument.parse(file.readAsStringSync());
      final titles = document.findAllElements('string');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      for (var element in titles) {
        print('${element.attributes.first.value}->${element.text}');
      }
    } else if (Platform.isIOS) {
      var path = ((await getLibraryDirectory()).path +
          "/Preferences/de.famprobst.report.plist");
      var file = File(path);

      NativeSharedPreferences prefs =
          await NativeSharedPreferences.getInstance();
      print(prefs.getString('goals_whole_60_optimal_1'));
    }
  }
}
