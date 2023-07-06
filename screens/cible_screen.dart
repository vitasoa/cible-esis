// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:convert';

import 'package:ciblesmionjo/models/cible_model.dart';
import 'package:ciblesmionjo/models/region_model.dart';
import 'package:ciblesmionjo/services/authentication_controller.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/screens/cible_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CibleScreen extends StatefulWidget {
  const CibleScreen({super.key});

  @override
  State<CibleScreen> createState() => _CibleScreenState();
}

class _CibleScreenState extends State<CibleScreen> {
  static const _storage = FlutterSecureStorage();
  DBHelper? dbHelper;
  String regionStr = '';
  late Future<List<CibleModel>> cibleList;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    cibleList = dbHelper!.getCibles();
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    regionStr = region.name!;
    setState(() {});
  }

  void _searchDatas(String cin) async {
    cibleList = dbHelper!.getCiblesCin(cin);
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
          "LISTE DES CIBLES GE/GMS ::: Région $regionStr",
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
              builder: (context, AsyncSnapshot<List<CibleModel>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Pas de Cibles enregistrés dans la Région",
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
                      String leadtext =
                          snapshot.data![index].categorie == 'Vulnérable'
                              ? 'GMS'
                              : 'GE';
                      String commune = snapshot.data![index].commune.toString();
                      String district =
                          snapshot.data![index].district.toString();
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
                                  bottom: 5,
                                ),
                                child: Text(
                                  "${cibleNom.toUpperCase()} $ciblePrenoms",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                "Contact : $cibleContact | CIN : $cibleCin | Date de délivrance : $cibleDateCin",
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
                                    "District : $district - Commune : $commune\n${cibleFonction.toUpperCase()} - $cibleCategorie",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Route route = MaterialPageRoute(
                                          builder: (context) => CibleForm(
                                                cibleId: cilbeId,
                                                cibleFokontany: cibleFokontany,
                                                cibleNom: cibleNom,
                                                ciblePrenoms: ciblePrenoms,
                                                cibleSexe: cibleSexe,
                                                cibleSituation: cibleSituation,
                                                cibleAges: cibleAges,
                                                cibleCin: cibleCin,
                                                cibleDateCin: cibleDateCin,
                                                cibleContact: cibleContact,
                                                cibleCategorie: cibleCategorie,
                                                cibleFonction: cibleFonction,
                                                cibleUpdate: true,
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
            Icons.person_add,
            size: 30,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (context) => CibleForm());
            Navigator.push(context, route).then(onGoBack);
          },
        ),
      ),
    );
  }

  onGoBack(dynamic value) {
    cibleList = dbHelper!.getCibles();
    _searchController.clear();
    setState(() {});
  }
}
