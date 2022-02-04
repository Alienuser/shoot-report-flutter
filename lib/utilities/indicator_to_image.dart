import 'package:flutter/material.dart';

class IndicatorImage {
  static Icon getIcon(int indicator) {
    switch (indicator) {
      case 0:
        return const Icon(Icons.sentiment_dissatisfied_outlined,
            color: Colors.red);
      case 1:
        return const Icon(Icons.sentiment_dissatisfied, color: Colors.red);
      case 2:
        return const Icon(Icons.sentiment_neutral_outlined,
            color: Colors.yellow);
      case 3:
        return const Icon(Icons.sentiment_satisfied, color: Colors.green);
      default:
        return const Icon(Icons.sentiment_satisfied, color: Colors.green);
    }
  }

  static String getString(int indicator) {
    switch (indicator) {
      case 0:
        return "\u{1F627}";
      case 1:
        return "\u{1F61F}";
      case 2:
        return "\u{1F610}";
      case 3:
        return "\u{1F600}";
      default:
        return "\u{1F601}";
    }
  }
}
