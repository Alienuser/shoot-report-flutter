import 'package:flutter/material.dart';

class AdsWidget extends StatefulWidget {
  final List<String> photos = [
    "1.jpg",
    "2.jpg",
    "3.jpg",
    "4.jpg",
    "5.jpg",
  ];

  AdsWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Image.asset(
        widget.photos[0],
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
