import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/type.dart';
import 'package:shoot_report/services/type_dao.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/discipline/discipline_type_row.dart';

class DisciplineTypeListView extends StatelessWidget {
  final TypeDao typeDao;
  final WeaponDao weaponDao;

  const DisciplineTypeListView(
      {super.key, required this.typeDao, required this.weaponDao});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(tr("weapon_favorite_title")),
                actions: <Widget>[
                  TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Icon(Icons.close),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(null)),
                ],
              ),
              body: StreamBuilder<List<Type>>(
                stream: typeDao.findAllTypes(),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  final groups = snapshot.requireData;

                  return ListView.separated(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return DisciplineTypeListCell(
                            type: groups[index], weaponDao: weaponDao);
                      },
                      separatorBuilder: (context, index) =>
                          const Divider(height: 5));
                },
              )),
        ),
      ),
    );
  }
}
