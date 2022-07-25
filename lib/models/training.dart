import 'package:floor/floor.dart';
import 'package:shoot_report/models/weapon.dart';

@Entity(
  primaryKeys: ['id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['weapon_id'],
      parentColumns: ['id'],
      entity: Weapon,
    )
  ],
)
class Training {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  DateTime date;

  String image;

  int indicator;

  String place;

  String kind;

  int shotCount;

  List shots;

  String comment;

  @ColumnInfo(name: 'weapon_id')
  final int weaponId;

  Training(this.id, this.date, this.image, this.indicator, this.place,
      this.kind, this.shotCount, this.shots, this.comment, this.weaponId);
}
