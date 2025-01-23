import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  var _pos = 1;
  Timer? _timer;
  final List<String> _photos = [
    "assets/images/partner_feinwerkbau.png",
    "assets/images/partner_sauer.png",
    "assets/images/partner_koch.png",
    "assets/images/partner_disag.png",
    "assets/images/partner_sauer_academy.png",
  ];

  @override
  void initState() {
    super.initState();
    if (_timer == null) {
      developer.log("Start Timer", name: "Widget-Ads");
      _setTimer();
    }
  }

  @override
  void deactivate() {
    if (_timer != null) {
      developer.log("Deactivate Timer", name: "Widget-Ads");
      _timer!.cancel();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return Container(
        color: (mode.brightness == Brightness.light)
            ? const Color(AppTheme.backgroundAdsLight)
            : const Color(AppTheme.backgroundAdsDark),
        height: 70,
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
        child: Image.asset(_photos[_pos], fit: BoxFit.contain));
  }

  void _setTimer() {
    var random = Random();
    _pos = random.nextInt(_photos.length);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _pos = (_pos + 1) % _photos.length;
      });
    });
  }
}
