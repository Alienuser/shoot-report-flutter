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
class Competition {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  DateTime date;

  String image;

  String place;

  String kind;

  int shotCount;

  List shots;

  String comment;

  @ColumnInfo(name: 'weapon_id')
  final int weaponId;

  Competition(this.id, this.date, this.image, this.place, this.kind,
      this.shotCount, this.shots, this.comment, this.weaponId);
}
