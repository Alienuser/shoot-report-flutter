import 'package:floor/floor.dart';
import 'dart:convert';

class ArrayConverter extends TypeConverter<List, String> {
  @override
  List decode(String databaseValue) {
    return jsonDecode(databaseValue);
  }

  @override
  String encode(List value) {
    return jsonEncode(value);
  }
}
