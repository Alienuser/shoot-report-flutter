import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shoot_report/models/type.dart';
import 'package:shoot_report/services/firebase_data_service.dart';
import 'package:shoot_report/views/discipline/discipline_type_row.dart';

class DisciplineTypeListView extends StatelessWidget {
  const DisciplineTypeListView({super.key});

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
                          IconButton(
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              icon:
                                  const Icon(Icons.close, color: Colors.white))
                        ]),
                    body: FutureBuilder<Map<String, dynamic>?>(
                        future: FirebaseDataService.getGlobalTypes(),
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                          final typesData = snapshot.data;
                          if (typesData == null || typesData.isEmpty) {
                            return const Center(child: Text('No types available'));
                          }
                          
                          final types = typesData.entries.map((entry) {
                            final data = entry.value;
                            Map<String, dynamic> typeData;
                            if (data is Map<String, dynamic>) {
                              typeData = data;
                            } else if (data is Map) {
                              typeData = Map<String, dynamic>.from(data);
                            } else {
                              return null;
                            }
                            return Type(typeData['id'], typeData['name'], typeData['order']);
                          }).where((type) => type != null).cast<Type>().toList();
                          
                          types.sort((a, b) => a.order.compareTo(b.order));
                          
                          return ListView.separated(
                              itemCount: types.length,
                              itemBuilder: (context, index) {
                                return DisciplineTypeListCell(type: types[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 5));
                        })
                    ))));
  }
}
