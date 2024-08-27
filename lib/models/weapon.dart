import 'package:floor/floor.dart';

@entity
class Weapon {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final int order;

  final String prefFile;

  final int typeId;

  bool show;

  Weapon(this.id, this.name, this.order, this.prefFile, this.typeId, this.show);
}
