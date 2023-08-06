import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/type.dart';
import 'package:shoot_report/services/weapon_dao.dart';
import 'package:shoot_report/views/favorite/favorite_sub.dart';

class FavoriteListCell extends StatelessWidget {
  final Type type;
  final WeaponDao weaponDao;

  const FavoriteListCell({
    Key? key,
    required this.type,
    required this.weaponDao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.legend_toggle_sharp),
        title: Text(tr(type.name)),
        trailing: const Icon(Icons.arrow_right_sharp, size: 35),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: true,
                      title: Text(tr(type.name)),
                      actions: <Widget>[
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            child: const Icon(Icons.close),
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(null)),
                      ],
                    ),
                    body:
                        FavoriteListSubView(type: type, weaponDao: weaponDao)),
              ));
        });
  }
}
