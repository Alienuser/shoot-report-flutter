import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shoot_report/models/competition.dart';
import 'package:shoot_report/models/training.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/utilities/indicator_to_image.dart';

class CsvConverter {
  static Future<String> generateTrainingCsv(
      Weapon weapon, Training training) async {
    num pointsTotal =
        training.shots.fold(0, (previous, current) => previous + current);
    num pointsAverage = (pointsTotal / training.shotCount);

    List<List<String>> data = [[], []];

    data[0].add(tr("export_training_weapon"));
    data[0].add(tr("export_training_evaluation"));
    data[0].add(tr("export_training_kind"));
    data[0].add(tr("export_training_location"));
    data[0].add(tr("export_training_date"));
    data[0].add(tr("export_training_shots"));
    data[0].add(tr("export_training_result"));
    data[0].add(tr("export_training_average"));
    for (var i = 0; i < training.shots.length; i++) {
      data[0].add(tr("export_training_serie", args: [(i + 1).toString()]));
    }
    data[0].add(tr("export_training_report"));

    data[1].add(tr(weapon.name));
    data[1].add(IndicatorImage.getString(training.indicator));
    data[1].add(training.kind);
    data[1].add(training.place);
    data[1].add(DateFormat.yMd().format(training.date));
    data[1].add(training.shotCount.toString());
    data[1].add(pointsTotal.toString().replaceAll(".", ","));
    data[1].add(pointsAverage.toStringAsFixed(2).replaceAll(".", ","));
    for (var i = 0; i < training.shots.length; i++) {
      data[1].add(training.shots[i].toString().replaceAll(".", ","));
    }
    data[1].add(training.comment);

    String csvData =
        const ListToCsvConverter(fieldDelimiter: ";").convert(data);
    List<int> csvBytes = [0xEF, 0xBB, 0xBF, ...utf8.encode(csvData)];
    final String directory = (await getTemporaryDirectory()).path;
    final path = "$directory/share_training.csv";

    final File file = File(path);
    await file.writeAsBytes(csvBytes);
    return path;
  }

  static Future<String> generateCompetitionCsv(
      Weapon weapon, Competition training) async {
    num pointsTotal =
        training.shots.fold(0, (previous, current) => previous + current);

    List<List<String>> data = [[], []];

    data[0].add(tr("export_competition_weapon"));
    data[0].add(tr("export_competition_kind"));
    data[0].add(tr("export_competition_location"));
    data[0].add(tr("export_competition_date"));
    data[0].add(tr("export_competition_shots"));
    data[0].add(tr("export_competition_result"));
    for (var i = 0; i < training.shots.length; i++) {
      data[0].add(tr("export_competition_serie", args: [(i + 1).toString()]));
    }
    data[0].add(tr("export_competition_report"));

    data[1].add(tr(weapon.name));
    data[1].add(training.kind);
    data[1].add(training.place);
    data[1].add(DateFormat.yMd().format(training.date));
    data[1].add(training.shotCount.toString());
    data[1].add(pointsTotal.toString().replaceAll(".", ","));
    for (var i = 0; i < training.shots.length; i++) {
      data[1].add(training.shots[i].toString().replaceAll(".", ","));
    }
    data[1].add(training.comment);

    String csvData =
        const ListToCsvConverter(fieldDelimiter: ";").convert(data);
    List<int> csvBytes = [0xEF, 0xBB, 0xBF, ...utf8.encode(csvData)];
    final String directory = (await getTemporaryDirectory()).path;
    final path = "$directory/share_competition.csv";

    final File file = File(path);
    await file.writeAsBytes(csvBytes);
    return path;
  }
}
