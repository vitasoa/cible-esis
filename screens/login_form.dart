// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:ciblesmionjo/screens/terms_screen.dart';
import 'package:ciblesmionjo/services/authentication_controller.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/services/synchronize_controller.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "/main";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _codeComune = '';

  void _resetDatabase(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Veuillez confirmer'),
          content: const Text(
              'Êtes-vous sûr de vider la base de données de paiement ?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                UtilsBehavior.showCircularIndicator(context);
                DBHelper().removeData();
                UtilsBehavior.hideCircularIndocator(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Base de données de paiement vide".toUpperCase(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                setState(() {
                  Navigator.of(context).pop();
                });
              },
              isDefaultAction: true,
              isDestructiveAction: true,
              child: const Text('OUI'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: false,
              isDestructiveAction: false,
              child: const Text('NON'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: const Text(
            "CIBLES GE/GMS",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 1,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                top: 0,
              ),
              child: PopupMenuButton<String>(
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                onSelected: (value) async {
                  switch (value) {
                    case 'Synchroniser les données':
                      UtilsBehavior.showCircularIndicator(context);
                      bool connected = await SynchronizeController()
                          .checkInternetConnectivity();
                      if (connected == true) {
                        int dCommunes = await DBHelper().synchroniseData();
                        String dSynchros = dCommunes.toString();
                        UtilsBehavior.hideCircularIndocator(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Données Système Synchronisées : $dSynchros - Communes"
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        break;
                      } else {
                        UtilsBehavior.hideCircularIndocator(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Problème de connexion au serveur central"
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        break;
                      }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Synchroniser les données'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: IconButton(
                  onPressed: () {
                    _resetDatabase(context);
                  },
                  tooltip: 'Clear database',
                  icon: const Icon(
                    Icons.clear_all,
                    size: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: IconButton(
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => const TermsScreen());
                    Navigator.push(context, route);
                  },
                  tooltip: 'Terms and Recommendations',
                  icon: const Icon(
                    Icons.help_outline_rounded,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 50.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icon.png',
                  height: 100.0,
                  width: 100.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'CIBLES GE/GMS',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        onChanged: (value) => setState(
                          () => _codeComune = value,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez renseigner le Code';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Entrer votre Code : XXXXXX-XXXXXX',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () async => {
                          if (_formKey.currentState!.validate())
                            {
                              await AuthenticationController()
                                  .processAuthentication(context, _codeComune)
                            },
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          ),
                          minimumSize: const Size(
                            150,
                            30,
                          ),
                          elevation: 0,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'Valider'.toUpperCase(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
