import 'dart:io';
import 'package:floor/floor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCallback {
  static final callback = Callback(onOpen: (database) async {
    print(database.path);
    // TODO Check if we have old data
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

    // TODO If no new data, check if we have no data to create weapons
  });
}
