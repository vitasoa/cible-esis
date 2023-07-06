// ignore_for_file: avoid_print, use_build_context_synchronously, unused_import

import 'dart:convert';

import 'package:ciblesmionjo/models/region_model.dart';
import 'package:ciblesmionjo/models/subvention_model.dart';
import 'package:ciblesmionjo/screens/subvention_screen.dart';
import 'package:ciblesmionjo/services/authentication_controller.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String _scanBarcode = 'Inconnu';
  static const _storage = FlutterSecureStorage();
  DBHelper? dbHelper;
  String regionStr = '';

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    regionStr = region.name!;
    setState(() {});
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "PAIEMENTS ::: Région $regionStr",
          style: const TextStyle(
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
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                'Paiement Cible QR-Scanner',
                style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    color: Color(0xFF1E1E1E)),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 20.0),
              child: const Text(
                'Veuillez donner accès à votre appareil photo afin que\n nous puissions scanner et vous fournir ce qu\'il y a\n à l\'intérieur du code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  height: 1.4,
                  color: Color(0xFFA0A0A0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Scan QR-Cible : $_scanBarcode\n',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => scanQR(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 5,
                ),
                minimumSize: const Size(
                  150,
                  30,
                ),
                elevation: 10,
                backgroundColor: const Color(0XFFFF7D54),
              ),
              child: const Text(
                "Scanner QR Code",
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_scanBarcode == 'Inconnu') {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return CupertinoAlertDialog(
                        title: const Text('QR-CODE Inconnu'),
                        content: const Text(
                            'Veuillez scanner la cibles avec son QR-CODE !'),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () {
                              setState(() {
                                _scanBarcode = 'Inconnu';
                              });
                              Navigator.of(context).pop();
                            },
                            isDefaultAction: false,
                            isDestructiveAction: false,
                            child: const Text('Revenir pour scanner'),
                          )
                        ],
                      );
                    },
                  );
                } else {
                  /** GET CIBLE POUR PAYER **/
                  var ciblePaiement = await dbHelper!
                      .getCiblePaiementDetails(_scanBarcode.toString());
                  if (ciblePaiement == null) {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return CupertinoAlertDialog(
                          title: const Text('QR-CODE Non reconnu'),
                          content: const Text(
                              'Veuillez re-scanner la cibles avec son QR-CODE, la cible n\'est pas disponible dans la base !'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                setState(() {
                                  _scanBarcode = 'Inconnu';
                                });
                                Navigator.of(context).pop();
                              },
                              isDefaultAction: false,
                              isDestructiveAction: false,
                              child: const Text('Revenir pour scanner'),
                            )
                          ],
                        );
                      },
                    );
                  }
                  if (ciblePaiement!.date_paiement != null &&
                      ciblePaiement.montant_subvention != null) {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return CupertinoAlertDialog(
                          title: Text(
                            'DEJA PAYE LE : ${ciblePaiement.date_paiement}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          content: Text(
                              'Vous avez été déjà payé.\nMONTANT DE LA SOMME : ${UtilsBehavior.formatCurrency(ciblePaiement.montant_subvention)} Ariary'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                setState(() {
                                  _scanBarcode = 'Inconnu';
                                });
                                Navigator.of(context).pop();
                              },
                              isDefaultAction: false,
                              isDestructiveAction: false,
                              child: const Text('Revenir pour scanner'),
                            )
                          ],
                        );
                      },
                    );
                  } else {
                    Subvention? subvForPay =
                        await dbHelper!.getLastSubventionDetails();
                    if (subvForPay != null) {
                      UtilsBehavior.showCircularIndicator(context);
                      await DBHelper().updateCiblePaiementData(
                        ciblePaiement.cin.toString(),
                        ciblePaiement.id_commune.toString(),
                        ciblePaiement.id.toString(),
                        subvForPay.date_sub.toString(),
                        subvForPay.id.toString(),
                        subvForPay.montant_beneficiaire.toString(),
                      );
                      UtilsBehavior.hideCircularIndocator(context);
                      Navigator.of(context).pop(true);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Paiement cible effectué : ${UtilsBehavior.formatCurrency(ciblePaiement.montant_subvention)} Ariary"
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(
                                20.0,
                              ),
                              height: MediaQuery.of(context).size.height * 2,
                              width: MediaQuery.of(context).size.width,
                              child: CupertinoAlertDialog(
                                title:
                                    const Text('PAS DE DONNEES DE SUBVENTION'),
                                content: const Text(
                                    'Le paiement nécessite une suvention pour chaque cible à payer.\nVeuillez en créer une pour votre action d\'aujourd\'hui !'),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Route route = MaterialPageRoute(
                                          builder: (context) =>
                                              const SubventionScreen());
                                      Navigator.push(context, route);
                                    },
                                    isDefaultAction: true,
                                    isDestructiveAction: true,
                                    child: const Text('SUBVENTION'),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    isDefaultAction: false,
                                    isDestructiveAction: false,
                                    child: const Text('ANNULER'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 90,
                  vertical: 5,
                ),
                minimumSize: const Size(
                  150,
                  30,
                ),
                elevation: 10,
                backgroundColor: Colors.teal,
              ),
              child: const Text(
                "Passer au paiement",
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
