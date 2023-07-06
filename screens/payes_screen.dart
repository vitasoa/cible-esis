// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_unnecessary_containers, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:convert';

import 'package:ciblesmionjo/models/cible_model_paiement.dart';
import 'package:ciblesmionjo/models/region_model.dart';
import 'package:ciblesmionjo/models/subvention_model.dart';
import 'package:ciblesmionjo/screens/paiement_form.dart';
import 'package:ciblesmionjo/screens/subvention_screen.dart';
import 'package:ciblesmionjo/services/authentication_controller.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PayesScreen extends StatefulWidget {
  const PayesScreen({super.key});

  @override
  State<PayesScreen> createState() => _PayesScreenState();
}

class _PayesScreenState extends State<PayesScreen> {
  static const _storage = FlutterSecureStorage();
  DBHelper? dbHelper;
  String regionStr = '';
  late Future<List<CibleModelPaiement>> cibleList;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadPayesData();
  }

  loadPayesData() async {
    cibleList = dbHelper!.getCiblesPayes();
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    regionStr = region.name!;
    setState(() {});
  }

  void _searchDatas(String cin) async {
    cibleList = dbHelper!.getCiblesPayesCin(cin);
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "CIBLES PAYES ::: REGION $regionStr",
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
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.all(
                10,
              ),
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _searchDatas(value);
                },
                decoration: InputDecoration(
                  labelText: 'Recherche',
                  suffixIcon: Icon(
                    Icons.search,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: cibleList,
              builder:
                  (context, AsyncSnapshot<List<CibleModelPaiement>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Pas de paiements enregistrés dans la Région",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      int cilbeId = snapshot.data![index].id!.toInt();
                      String cibleFokontany =
                          snapshot.data![index].fokontany.toString();
                      String cibleNom = snapshot.data![index].nom.toString();
                      String ciblePrenoms =
                          snapshot.data![index].prenoms.toString();
                      String cibleSexe = snapshot.data![index].sexe.toString();
                      String cibleSituation =
                          snapshot.data![index].situation.toString();
                      String cibleAges = snapshot.data![index].ages.toString();
                      String cibleCin = snapshot.data![index].cin.toString();
                      String cibleDateCin =
                          snapshot.data![index].date_cin.toString();
                      String cibleContact =
                          snapshot.data![index].contact.toString();
                      String cibleCategorie =
                          snapshot.data![index].categorie.toString();
                      String cibleFonction =
                          snapshot.data![index].fonction.toString();
                      String cibleCommuneId =
                          snapshot.data![index].id_commune.toString();
                      String cibleIdSubvention =
                          snapshot.data![index].id_subvention.toString();
                      String cibleMontantSubvention =
                          snapshot.data![index].montant_subvention.toString();
                      String cibleSubvention =
                          snapshot.data![index].subvention.toString();
                      String cibleSubventionDatePaiement =
                          snapshot.data![index].date_paiement.toString();
                      String cibleSubventionResponsable =
                          snapshot.data![index].nom_responsable.toString();
                      String leadtext =
                          snapshot.data![index].categorie == 'Vulnérable'
                              ? 'GMS'
                              : 'GE';
                      String commune = snapshot.data![index].commune.toString();
                      String district =
                          snapshot.data![index].district.toString();
                      bool payCible = false;
                      if (cibleMontantSubvention == 'null') {
                        if (cibleIdSubvention == 'null') {
                          payCible = true;
                        }
                      }

                      return Container(
                        margin: EdgeInsets.all(
                          10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: Text(
                                  leadtext,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Padding(
                                padding: EdgeInsets.only(
                                  bottom: 1,
                                ),
                                child: Text(
                                  "${cibleNom.toUpperCase()} $ciblePrenoms",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(
                                  top: 2.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Contact : $cibleContact | CIN : $cibleCin | Date de délivrance : $cibleDateCin",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    payCible == false
                                        ? Text(
                                            "Subv. $cibleSubvention | Date de paiement : $cibleSubventionDatePaiement | Responsable : $cibleSubventionResponsable | Montant : ${UtilsBehavior.formatCurrency(cibleMontantSubvention)} Ariary",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.brown,
                                            ),
                                          )
                                        : Text('...'),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.brown,
                              thickness: 0.8,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "District : $district - Commune : $commune",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  payCible == true
                                      ? InkWell(
                                          onTap: () async {
                                            Subvention? subvForPay =
                                                await dbHelper!
                                                    .getLastSubventionDetails();
                                            if (subvForPay != null) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return PaiementManuelForm(
                                                    cibleId: cilbeId,
                                                    cibleCommuneId:
                                                        cibleCommuneId,
                                                    cibleNom: cibleNom,
                                                    ciblePrenoms: ciblePrenoms,
                                                    cibleCin: cibleCin,
                                                    cibleDateCin: cibleDateCin,
                                                    cibleCommune: commune,
                                                    cibleDistrict: district,
                                                    subv: subvForPay,
                                                  );
                                                },
                                              ).then(onGoBack);
                                            } else {
                                              showCupertinoDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Center(
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                        20.0,
                                                      ),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              2,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child:
                                                          CupertinoAlertDialog(
                                                        title: const Text(
                                                            'PAS DE DONNEES DE SUBVENTION'),
                                                        content: const Text(
                                                            'Le paiement nécessite une suvention pour chaque cible à payer.\nVeuillez en créer une pour votre action d\'aujourd\'hui !'),
                                                        actions: [
                                                          CupertinoDialogAction(
                                                            onPressed: () {
                                                              Route route =
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const SubventionScreen());
                                                              Navigator.push(
                                                                  context,
                                                                  route);
                                                            },
                                                            isDefaultAction:
                                                                true,
                                                            isDestructiveAction:
                                                                true,
                                                            child: const Text(
                                                                'SUBVENTION'),
                                                          ),
                                                          CupertinoDialogAction(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            isDefaultAction:
                                                                false,
                                                            isDestructiveAction:
                                                                false,
                                                            child: const Text(
                                                                'ANNULER'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Icon(
                                            Icons.arrow_circle_right_outlined,
                                            size: 35,
                                            color: Colors.amber,
                                          ),
                                        )
                                      : Text('...'),
                                  // : InkWell(
                                  //     onTap: () async {
                                  //       await DBHelper()
                                  //           .updateCiblePaiementDataNull(
                                  //               cilbeId.toString());
                                  //     },
                                  //     child: Icon(
                                  //       Icons.remove_circle_outline,
                                  //       size: 35,
                                  //       color: Colors.amber,
                                  //     ),
                                  //   ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  onGoBack(dynamic value) {
    cibleList = dbHelper!.getCiblesPayes();
    _searchController.clear();
    setState(() {});
  }
}
