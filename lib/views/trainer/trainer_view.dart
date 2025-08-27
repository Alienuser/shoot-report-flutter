import 'package:flutter/material.dart';
import 'package:shoot_report/utilities/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrainerViewWidget extends StatefulWidget {
  final String url;

  const TrainerViewWidget({super.key, required this.url});

  @override
  State<TrainerViewWidget> createState() => _TrainerViewWidgetState();
}

class _TrainerViewWidgetState extends State<TrainerViewWidget> {
  final host = "https://trainer.burkhardt-sport.solutions";
  final validLocales = ["de", "en"];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var locale = Localizations.localeOf(context).toString();
    var language = validLocales.contains(locale) ? locale : 'en';

    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(AppTheme.backgroundColorLight))
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (String url) {
        /*setState(() {
          isLoading = true;
        });*/
      }, onPageFinished: (String url) {
        /*setState(() {
          isLoading = false;
        });*/
      }, onNavigationRequest: (NavigationRequest request) {
        if (!request.url.contains(host)) {
          launchUrl(
            Uri.parse(request.url),
            mode: LaunchMode.externalApplication,
          );
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      }))
      ..loadRequest(Uri.parse("$host/$language/${widget.url}"));

    return Scaffold(
        body: Stack(children: [
      WebViewWidget(controller: controller),
      Visibility(
          visible: isLoading,
          child: const Center(
            child: CircularProgressIndicator(),
          ))
    ]));
  }
}
