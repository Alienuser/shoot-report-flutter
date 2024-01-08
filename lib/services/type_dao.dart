import 'package:floor/floor.dart';
import 'package:shoot_report/models/type.dart';

@dao
abstract class TypeDao {
  @Query("SELECT * FROM type ORDER by \"order\" ASC;")
  Stream<List<Type>> findAllTypes();

  @insert
  Future<void> insertGroup(Type type);

  @update
  Future<void> updateGroup(Type type);

  @delete
  Future<void> deleteGroup(Type type);
}
