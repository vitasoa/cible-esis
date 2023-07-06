// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print, prefer_final_fields

import 'dart:convert';

import 'package:ciblesmionjo/models/region_model.dart';
import 'package:ciblesmionjo/screens/cible_screen.dart';
import 'package:ciblesmionjo/screens/paiement_screen.dart';
import 'package:ciblesmionjo/screens/payes_screen.dart';
import 'package:ciblesmionjo/screens/qr_screen.dart';
import 'package:ciblesmionjo/screens/subvention_screen.dart';
import 'package:ciblesmionjo/services/authentication_controller.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/services/synchronize_controller.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _storage = FlutterSecureStorage();
  DBHelper? dbHelper;
  String regionStr = '';
  String cibles = '0';
  String gms = '0';
  String ge = '0';
  String subv = '0';
  String paiements = '0';
  List<int> cInfos = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadInfos();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  loadInfos() async {
    cInfos = await dbHelper!.getInformationsRegion();
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    regionStr = region.name!;
    setState(() {});
  }

  onGoBack(dynamic value) async {
    cInfos = await dbHelper!.getInformationsRegion();
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    regionStr = region.name!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (cInfos.isNotEmpty) {
      cibles = cInfos[3].toString();
      gms = cInfos[4].toString();
      ge = cInfos[5].toString();
      subv = cInfos[6].toString();
      paiements = cInfos[7].toString();
    }
    String drawerRegion = '';
    if (regionStr.length > 20) {
      var cSplited = regionStr.split(' ');
      if (cSplited.length > 1) {
        drawerRegion = cSplited[0];
        if (drawerRegion.length > 20) {
          drawerRegion = drawerRegion.substring(0, 20);
        }
      } else {
        drawerRegion = regionStr.substring(0, 20);
      }
    } else {
      drawerRegion = regionStr;
    }
    return Scaffold(
      drawer: Drawer(
        elevation: 10.0,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey.shade500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 40.0,
                    child: Text(
                      'GE / GMS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        drawerRegion,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        '::: Projet Mionjo :::',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'Clible GE / GMS',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const Divider(
              height: 3.0,
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text(
                'Enregistrement cibles',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                    builder: (context) => const CibleScreen());
                Navigator.push(context, route).then(onGoBack);
              },
            ),
            const Divider(
              height: 3.0,
            ),
            ListTile(
              leading: const Icon(Icons.euro_outlined),
              title: const Text(
                'Soutiens à la consommation',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                    builder: (context) => const SubventionScreen());
                Navigator.push(context, route).then(onGoBack);
              },
            ),
            const Divider(
              height: 3.0,
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner_sharp),
              title: const Text(
                'Paiement QR-CODE',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Route route =
                    MaterialPageRoute(builder: (context) => const QRScreen());
                Navigator.push(context, route).then(onGoBack);
              },
            ),
            const Divider(
              height: 3.0,
            ),
            ListTile(
              leading: const Icon(Icons.markunread),
              title: const Text(
                'Paiement simple - Cibles non payés',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                    builder: (context) => const PaiementScreen());
                Navigator.push(context, route).then(onGoBack);
              },
            ),
            ListTile(
              leading: const Icon(Icons.markunread),
              title: const Text(
                'Cibles payés',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                    builder: (context) => const PayesScreen());
                Navigator.push(context, route).then(onGoBack);
              },
            ),
            const Divider(
              height: 3.0,
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text(
                'Fermer le volet',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const Divider(
              height: 3.0,
            ),
          ],
        ),
      ),
      appBar: AppBar(
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
            padding: const EdgeInsets.only(right: 20, top: 0),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 40),
              elevation: 2,
              child: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) async {
                switch (value) {
                  case 'Déconnexion':
                    await AuthenticationController().processLogout(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Déconnexion ...".toUpperCase(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Déconnexion'}.map((String choice) {
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
                right: 10,
              ),
              child: IconButton(
                onPressed: () async {
                  UtilsBehavior.showCircularIndicator(context);
                  bool connected =
                      await SynchronizeController().checkInternetConnectivity();
                  if (connected == true) {
                    int dCibles = await DBHelper().getCiblesData();
                    String intCibles = dCibles.toString();
                    UtilsBehavior.hideCircularIndocator(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Cibles du serveur central Synchronisés : $intCibles"
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
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
                  }
                },
                tooltip: 'Importer les cibles pour paiement',
                icon: const Icon(
                  Icons.cloud_download,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: IconButton(
                onPressed: () async {
                  UtilsBehavior.showCircularIndicator(context);
                  bool connected =
                      await SynchronizeController().checkInternetConnectivity();
                  if (connected) {
                    await SynchronizeController().sendSynchroniseData();
                    UtilsBehavior.hideCircularIndocator(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        padding: const EdgeInsets.all(30.0),
                        content: Text(
                          "Vous données sont envoyées au serveur central ..."
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    debugPrint('Device not connected');
                    UtilsBehavior.hideCircularIndocator(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        padding: const EdgeInsets.all(30.0),
                        content: Text(
                          "Vous n'êtes pas connecté(e) au serveur central ..."
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                tooltip: 'Synchroniser vers le serveur',
                icon: const Icon(
                  Icons.sync,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          30.0,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.png',
                height: 50.0,
                width: 50.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Column(
                children: [
                  const Text(
                    'ENREGISTREMENT CIBLES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ).alignment(Alignment.center).padding(bottom: 20),
                  <Widget>[_buildUserRow(), _buildUserStats()]
                      .toColumn(
                          mainAxisAlignment: MainAxisAlignment.spaceAround)
                      .padding(horizontal: 20, vertical: 10)
                      .decorated(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(10))
                      .elevation(
                        2,
                        shadowColor: const Color(0xff3977ff),
                        borderRadius: BorderRadius.circular(20),
                      )
                      .height(150)
                      .alignment(Alignment.center),
                  const SizedBox(
                    height: 2,
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(
                          5,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(
                                2,
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) => const CibleScreen());
                                Navigator.push(context, route).then(onGoBack);
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.person_add,
                                  ),
                                ),
                              ),
                              title: const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 1,
                                ),
                                child: Text(
                                  "Enregistrement cibles",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              subtitle: const Text(
                                "Mise en œuvre des sous projets",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(
                          5,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(
                                2,
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                        const SubventionScreen());
                                Navigator.push(context, route).then(onGoBack);
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.euro_outlined,
                                  ),
                                ),
                              ),
                              title: const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 1,
                                ),
                                child: Text(
                                  "Soutiens à la consommation",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              subtitle: const Text(
                                "Mise en œuvre des sous projets",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(
                          5,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(
                                2,
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) => const QRScreen());
                                Navigator.push(context, route).then(onGoBack);
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.euro_outlined,
                                  ),
                                ),
                              ),
                              title: const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 1,
                                ),
                                child: Text(
                                  "Paiement QR CODE",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              subtitle: const Text(
                                "Mise en œuvre des sous projets",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(
                          5,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(
                                2,
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                        const PaiementScreen());
                                Navigator.push(context, route).then(onGoBack);
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.euro_outlined,
                                  ),
                                ),
                              ),
                              title: const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 1,
                                ),
                                child: Text(
                                  "Paiement simple - Cibles non payés",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              subtitle: const Text(
                                "Mise en œuvre des sous projets",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(
                          5,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(
                                2,
                              ),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) => const PayesScreen());
                                Navigator.push(context, route).then(onGoBack);
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.euro_outlined,
                                  ),
                                ),
                              ),
                              title: const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 1,
                                ),
                                child: Text(
                                  "Cibles payés",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              subtitle: const Text(
                                "Mise en œuvre des sous projets",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: SizedBox(
      //   height: 30,
      //   width: 300,
      //   child: FloatingActionButton.extended(
      //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //     onPressed: () async {
      //       UtilsBehavior.showCircularIndicator(context);
      //       bool connected =
      //           await SynchronizeController().checkInternetConnectivity();
      //       if (connected) {
      //         await SynchronizeController().sendSynchroniseData();
      //         UtilsBehavior.hideCircularIndocator(context);
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(
      //             padding: const EdgeInsets.all(30.0),
      //             content: Text(
      //               "Vous données sont envoyées au serveur central ..."
      //                   .toUpperCase(),
      //               textAlign: TextAlign.center,
      //             ),
      //           ),
      //         );
      //       } else {
      //         debugPrint('Device not connected');
      //         UtilsBehavior.hideCircularIndocator(context);
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(
      //             padding: const EdgeInsets.all(30.0),
      //             content: Text(
      //               "Vous n'êtes pas connecté(e) au serveur central ..."
      //                   .toUpperCase(),
      //               textAlign: TextAlign.center,
      //             ),
      //           ),
      //         );
      //       }
      //     },
      //     label: const Text(
      //       'Synchroniser vers le serveur',
      //       style: TextStyle(
      //         fontSize: 12.0,
      //       ),
      //     ),
      //     icon: const Icon(Icons.sync),
      //     backgroundColor: Colors.brown,
      //     elevation: 0,
      //     tooltip: 'Synchroniser vers le serveur',
      //     extendedPadding:
      //         const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      //   ),
      // ),
      // bottomSheet: const Padding(
      //   padding: EdgeInsets.only(
      //     bottom: 60.0,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildUserRow() {
    return <Widget>[
      const Icon(Icons.account_circle)
          .decorated(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          )
          .constrained(height: 50, width: 50)
          .padding(right: 10),
      <Widget>[
        const Text(
          'Processus de constitution des GE et GMS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ).padding(bottom: 5),
        Text(
          'Région : $regionStr',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
          ),
        ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    ].toRow();
  }

  Widget _buildUserStats() {
    return <Widget>[
      _buildUserStatsItem(cibles, 'Cibles'),
      _buildUserStatsItem(gms, 'GMS'),
      _buildUserStatsItem(ge, 'GE'),
      _buildUserStatsItem(subv, 'Subventions'),
      _buildUserStatsItem(paiements, 'Paiements'),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padding(vertical: 10);
  }

  Widget _buildUserStatsItem(String value, String text) => <Widget>[
        Text(value).fontSize(16).textColor(Colors.white).padding(bottom: 5),
        Text(text).textColor(Colors.white.withOpacity(0.6)).fontSize(12),
      ].toColumn();
}
