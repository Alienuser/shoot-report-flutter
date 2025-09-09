import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shoot_report/models/weapon.dart';
import 'package:shoot_report/services/firebase_data_service.dart';

class DisciplineWeaponListCell extends StatefulWidget {
  final Weapon weapon;

  const DisciplineWeaponListCell({super.key, required this.weapon});

  @override
  State<DisciplineWeaponListCell> createState() => _DisciplineWeaponListCellState();
}

class _DisciplineWeaponListCellState extends State<DisciplineWeaponListCell> {
  bool _isVisible = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVisibility();
  }

  void _loadVisibility() async {
    final visibility = await FirebaseDataService.getWeaponVisibility(widget.weapon.id.toString());
    if (mounted) {
      setState(() {
        _isVisible = visibility;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.asset("assets/images/disciplines_weapon.png", height: 16),
        title: Text(tr(widget.weapon.name)),
        trailing: _isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : IconButton(
                onPressed: () {
                  _updateFavorite();
                },
                icon: Icon(_isVisible ? Icons.star : Icons.star_outline)));
  }

  void _updateFavorite() async {
    final newVisibility = !_isVisible;
    await FirebaseDataService.setWeaponVisibility(widget.weapon.id.toString(), newVisibility);
    if (mounted) {
      setState(() {
        _isVisible = newVisibility;
      });
    }
  }
}
