// ignore_for_file: use_build_context_synchronously

import 'package:ciblesmionjo/screens/home_screen.dart';
import 'package:ciblesmionjo/screens/login_form.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationController {
  final _storage = const FlutterSecureStorage();

  Future<void> processLogout(BuildContext context) async {
    await _storage.delete(key: "commune");
    await _storage.delete(key: "commune");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> processAuthentication(BuildContext context, String code) async {
    UtilsBehavior.showCircularIndicator(context);
    if (await DBHelper().authenticate(code)) {
      debugPrint("Authentifié");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      UtilsBehavior.hideCircularIndocator(context);
      debugPrint("Erreur d'Authentification ...");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erreur d'Authentification ...".toUpperCase(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
