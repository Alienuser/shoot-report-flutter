import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:developer';

class FirebaseLog {
  void logScreenView(String screenClass, String screenName) async {
    log("Screen: $screenName", name: "FirebaseLog");
    FirebaseAnalytics.instance
        .logScreenView(screenClass: screenClass, screenName: screenName);
  }

  void logEvent(String event) {
    log("Event: $event", name: "FirebaseLog");
    FirebaseAnalytics.instance.logEvent(name: event);
  }

  void logAppStart() {
    log("App start.", name: "FirebaseLog");
    FirebaseAnalytics.instance.logAppOpen();
  }
}
