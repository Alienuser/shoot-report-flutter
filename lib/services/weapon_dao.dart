import '../models/weapon.dart';
import 'package:floor/floor.dart';

@dao
abstract class WeaponDao {
  @Query("SELECT * FROM weapon WHERE show = true ORDER by \"order\" ASC")
  Stream<List<Weapon>> findAllWeapons();

  @insert
  Future<void> insertWeapon(Weapon weapon);

  @update
  Future<void> updateWeapon(Weapon weapon);

  @delete
  Future<void> deleteWeapon(Weapon weapon);

  @Query("Update weapon SET show=true")
  Future<void> showAllWeapons();
}
