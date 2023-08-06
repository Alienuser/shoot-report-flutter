import 'package:floor/floor.dart';
import 'package:shoot_report/models/weapon.dart';

@dao
abstract class WeaponDao {
  @Query("SELECT * FROM weapon ORDER by \"order\" ASC;")
  Stream<List<Weapon>> findAllWeapons();

  @Query("SELECT * FROM weapon WHERE typeId = :id ORDER by \"order\" ASC;")
  Stream<List<Weapon>> findAllWeaponsForType(int id);

  @Query(
      "SELECT * FROM weapon WHERE favorite = :favorite ORDER by \"order\" ASC;")
  Stream<List<Weapon>> findAllWeaponsDistinction(bool favorite);

  @insert
  Future<void> insertWeapon(Weapon weapon);

  @update
  Future<void> updateWeapon(Weapon weapon);

  @delete
  Future<void> deleteWeapon(Weapon weapon);
}
