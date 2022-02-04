import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrainerViewWidget extends StatefulWidget {
  final String url;

  const TrainerViewWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<TrainerViewWidget> createState() => _TrainerViewWidgetState();
}

class _TrainerViewWidgetState extends State<TrainerViewWidget> {
  final host = "https://trainer.burkhardt-sport.solutions";
  final validLocales = ["de", "en"];

  @override
  Widget build(BuildContext context) {
    var locale = Localizations.localeOf(context).toString();
    var language = validLocales.contains(locale) ? locale : 'en';

    return Scaffold(
      body: WebView(
        initialUrl: "$host/$language/${widget.url}",
        navigationDelegate: (NavigationRequest request) {
          if (!request.url.contains(host)) {
            launch(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
