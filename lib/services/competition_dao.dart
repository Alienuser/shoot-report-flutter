import 'package:shoot_report/models/competition.dart';
import 'package:floor/floor.dart';

@dao
abstract class CompetitionDao {
  @Query('SELECT * FROM competition')
  Stream<List<Competition>> findAllCompetitions();

  @Query('SELECT * FROM competition WHERE weapon_id = :wid ORDER by date DESC')
  Stream<List<Competition>> findAllCompetitionForWeapon(int wid);

  @insert
  Future<void> insertCompetition(Competition competition);

  @update
  Future<void> updateCompetition(Competition competition);

  @delete
  Future<void> deleteCompetition(Competition competition);
}
