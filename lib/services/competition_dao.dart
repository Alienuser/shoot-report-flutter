import 'package:shoot_report/models/competition.dart';
import 'package:floor/floor.dart';

@dao
abstract class CompetitionDao {
  @Query('SELECT * FROM competition')
  Stream<List<Competition>> findAllCompetitions();

  @Query('SELECT * FROM competition WHERE weapon_id = :wid')
  Stream<List<Competition>> findAllTrainingsForWeapon(int wid);

  @insert
  Future<void> insertCompetition(Competition competition);

  @delete
  Future<void> deleteCompetition(Competition competition);
}
