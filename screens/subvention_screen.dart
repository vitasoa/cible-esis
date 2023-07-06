// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:convert';

import 'package:ciblesmionjo/models/region_model.dart';
import 'package:ciblesmionjo/models/subvention_model.dart';
import 'package:ciblesmionjo/screens/subvention_form.dart';
import 'package:ciblesmionjo/services/authentication_controller.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubventionScreen extends StatefulWidget {
  const SubventionScreen({super.key});

  @override
  State<SubventionScreen> createState() => _SubventionScreenState();
}

class _SubventionScreenState extends State<SubventionScreen> {
  static const _storage = FlutterSecureStorage();
  DBHelper? dbHelper;
  String regionStr = '';
  late Future<List<Subvention>> subvList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadSuventionData();
  }

  loadSuventionData() async {
    subvList = dbHelper!.getSubventions();
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    regionStr = region.name!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "LISTE DES SUBVENTIONS GE/GMS ::: Région $regionStr",
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
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: subvList,
              builder: (context, AsyncSnapshot<List<Subvention>> snapshot) {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Pas de Subventions enregistrées dans la Région",
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
                      int subventionId = snapshot.data![index].id!.toInt();
                      String subvDate =
                          snapshot.data![index].date_sub.toString();
                      String subvLieu = snapshot.data![index].lieu.toString();
                      String subvResponsable =
                          snapshot.data![index].nom_responsable.toString();
                      String subvMontant =
                          snapshot.data![index].montant_beneficiaire.toString();

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
                                child: Icon(Icons.monetization_on_outlined),
                              ),
                              title: Padding(
                                padding: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                child: Text(
                                  "Subv. - $subvDate || Lieu de paiement : ${subvLieu.toUpperCase()}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                "Responsable : $subvResponsable | Date : $subvDate",
                                style: TextStyle(
                                  fontSize: 14,
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
                                    "Montant par bénéficiare : ${UtilsBehavior.formatCurrency(subvMontant)} Ariary - Région : $regionStr",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Route route = MaterialPageRoute(
                                          builder: (context) => SubventionForm(
                                                subvId: subventionId,
                                                subvDate: subvDate,
                                                subvLieu: subvLieu,
                                                subvMontant: subvMontant,
                                                subvResponsable:
                                                    subvResponsable,
                                                subvUpdate: true,
                                              ));
                                      Navigator.push(context, route)
                                          .then(onGoBack);
                                    },
                                    child: Icon(
                                      Icons.edit_note,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
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
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.brown,
          child: Icon(
            Icons.monetization_on_sharp,
            size: 30,
          ),
          onPressed: () {
            Route route =
                MaterialPageRoute(builder: (context) => SubventionForm());
            Navigator.push(context, route).then(onGoBack);
          },
        ),
      ),
    );
  }

  onGoBack(dynamic value) {
    subvList = dbHelper!.getSubventions();
    setState(() {});
  }
}
