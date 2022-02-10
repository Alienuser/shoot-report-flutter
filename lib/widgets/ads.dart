import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  var _pos = 1;
  Timer? _timer;
  final List<String> _photos = [
    "assets/images/100.png",
    "assets/images/100.png",
    "assets/images/100.png",
    "assets/images/100.png",
    "assets/images/100.png",
    "assets/images/100.png",
  ];

  @override
  void initState() {
    super.initState();
    if (_timer == null) {
      print("Start Timer");
      _setTimer();
    }
  }

  @override
  void deactivate() {
    if (_timer != null) {
      print('Deactivate Timer');
      _timer!.cancel();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    var whichMode = mode.brightness;
    return Container(
      color: (whichMode == Brightness.light)
          ? const Color(AppTheme.backgroundAdsLight)
          : const Color(AppTheme.backgroundAdsDark),
      height: 90,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Image.asset(
        _photos[_pos],
        fit: BoxFit.fitHeight,
      ),
    );
  }

  void _setTimer() {
    var random = Random();
    _pos = random.nextInt(_photos.length);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _pos = (_pos + 1) % _photos.length;
        print("New Image: $_pos");
      });
    });
  }
}
