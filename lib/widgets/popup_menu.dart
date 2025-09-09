import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoot_report/services/auth_service.dart';
import 'package:shoot_report/utilities/firebase_log.dart';
import 'package:shoot_report/widgets/cooperation.dart';
import 'package:shoot_report/widgets/information.dart';
import 'package:shoot_report/widgets/partner.dart';
import 'package:url_launcher/url_launcher.dart';

class PopupMenuWidget extends StatefulWidget {
  const PopupMenuWidget({super.key});

  @override
  State<StatefulWidget> createState() => _PopupMenuWidget();
}

class _PopupMenuWidget extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(tr("menu_information")),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text(tr("menu_partner")),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text(tr("menu_cooperation")),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text(tr("menu_facebook")),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Text(tr("menu_instagram")),
              ),
              /*PopupMenuItem<int>(
                value: 5,
                child: Text(tr("menu_create_account")),
              ),*/
            ],
        onSelected: (item) {
          switch (item) {
            case 0:
              showBarModalBottomSheet(
                expand: true,
                context: context,
                builder: (context) => const InformationWidget(),
              );
              break;
            case 1:
              showBarModalBottomSheet(
                context: context,
                expand: true,
                builder: (context) => const PartnerWidget(),
              );
              break;
            case 2:
              showBarModalBottomSheet(
                context: context,
                expand: true,
                builder: (context) => const CooperationWidget(),
              );
              break;
            case 3:
              FirebaseLog().logEvent("Facebook");
              launchUrl(
                Uri.parse("https://facebook.com/shoot.report"),
                mode: LaunchMode.externalApplication,
              );
              break;
            case 4:
              FirebaseLog().logEvent("Instagram");
              launchUrl(
                Uri.parse("https://instagram.com/shoot.report"),
                mode: LaunchMode.externalApplication,
              );
              break;
            case 5:
              FirebaseLog().logEvent("Create Account");
              _showCreateAccountDialog(context);
              break;
          }
        });
  }

  void _showCreateAccountDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr("create_account_title")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: tr("email"),
                hintText: "user@example.com",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: tr("password"),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Text(
              tr("create_account_info"),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr("general_cancel")),
          ),
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              final password = passwordController.text;

              if (email.isEmpty || password.isEmpty) {
                return;
              }

              Navigator.of(context).pop();
              await _createAccount(context, email, password);
            },
            child: Text(tr("create_account_button")),
          ),
        ],
      ),
    );
  }

  Future<void> _createAccount(
      BuildContext context, String email, String password) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Creating account..."),
            ],
          ),
        ),
      );

      await AuthService.createAccountAndMigrateData(email, password);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading

        // Show success
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(tr("success")),
            content: Text(tr("account_created_success")),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(tr("general_ok")),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading

        // Show error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(tr("error")),
            content: Text(tr("account_creation_failed")),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(tr("general_ok")),
              ),
            ],
          ),
        );
      }
    }
  }
}
