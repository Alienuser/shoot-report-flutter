import 'package:shoot_report/models/training.dart';
import 'package:floor/floor.dart';

@dao
abstract class TrainingDao {
  @Query('SELECT * FROM training')
  Stream<List<Training>> findAllTrainings();

  @Query('SELECT * FROM training WHERE weapon_id = :wid ORDER by date DESC')
  Stream<List<Training>> findAllTrainingsForWeapon(int wid);

  @insert
  Future<void> insertTraining(Training training);

  @update
  Future<void> updateTraining(Training training);

  @delete
  Future<void> deleteTraining(Training training);
}
