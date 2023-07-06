// ignore_for_file: unused_import, must_be_immutable, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:ciblesmionjo/models/cible_model.dart';
import 'package:ciblesmionjo/models/commune_model.dart';
import 'package:ciblesmionjo/models/district_model.dart';
import 'package:ciblesmionjo/models/region_model.dart';
import 'package:ciblesmionjo/models/subvention_model.dart';
import 'package:ciblesmionjo/services/authentication_controller.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:basic_utils/basic_utils.dart';

class SubventionForm extends StatefulWidget {
  int? subvId;
  String? subvDate;
  String? subvLieu;
  String? subvResponsable;
  String? subvMontant;
  bool? subvUpdate;

  SubventionForm({
    this.subvId,
    this.subvDate,
    this.subvLieu,
    this.subvResponsable,
    this.subvMontant,
    this.subvUpdate,
  });

  @override
  State<SubventionForm> createState() => _CibleFormState();
}

class _CibleFormState extends State<SubventionForm> {
  static const _storage = FlutterSecureStorage();
  DBHelper? dbHelper;
  String regionStr = '';
  late Future<List<Subvention>> subvList;

  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final lieuController = TextEditingController();
  final responsableController = TextEditingController();
  final montantController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
    dateController.text = (widget.subvDate ?? '');
    lieuController.text = (widget.subvLieu ?? '');
    responsableController.text = (widget.subvResponsable ?? '');
    montantController.text = (widget.subvMontant ?? '');
  }

  loadData() async {
    subvList = dbHelper!.getSubventions();
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    regionStr = region.name!;
    setState(() {});
  }

  String capitalizeTitle(String input) {
    if (input != '') {
      final List<String> splitStr = input.split(' ');
      for (int i = 0; i < splitStr.length; i++) {
        splitStr[i] =
            '${splitStr[i][0].toUpperCase()}${splitStr[i].toLowerCase().substring(1)}';
      }
      final output = splitStr.join(' ');
      return output;
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    String submitButton;
    if (widget.subvUpdate == true) {
      appBarTitle =
          "METTRE A JOUR LA SUBVENTION : ${widget.subvLieu} ${widget.subvDate}";
      submitButton = "Envoyer";
    } else {
      appBarTitle = "AJOUTER UNE SUBVENTION";
      submitButton = "Créer la subvention";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          appBarTitle,
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
      body: Padding(
        padding: EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "::: Informations de la Subvention - REGION $regionStr :::",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: responsableController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Responsable'),
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Entrer le nom du responsable !';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: lieuController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Lieu'),
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Entrer le lieu du paiement !';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "::: Détails de la subvention :::",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              controller: montantController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Montant bénéficiaire'),
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Entrer le montant du beneficiaire !';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: dateController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                icon: Icon(Icons.calendar_today),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Date de paiement'),
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2030));
                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  setState(() {
                                    dateController.text = formattedDate;
                                  });
                                } else {
                                  print("Date non sélectionnée");
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Entrer la date de paiement de la subvention !';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.subvUpdate == true) {
                              dbHelper!.updateSubv(
                                Subvention(
                                  id: widget.subvId,
                                  lieu:
                                      lieuController.text.trim().toUpperCase(),
                                  date_sub: dateController.text,
                                  nom_responsable: responsableController.text
                                      .trim()
                                      .toUpperCase(),
                                  montant_beneficiaire: montantController.text,
                                ),
                              );
                            } else {
                              dbHelper!.insertSubv(
                                Subvention(
                                  lieu:
                                      lieuController.text.trim().toUpperCase(),
                                  date_sub: dateController.text,
                                  nom_responsable: responsableController.text
                                      .trim()
                                      .toUpperCase(),
                                  montant_beneficiaire: montantController.text,
                                ),
                              );
                            }
                            Navigator.of(context).pop(true);
                            lieuController.clear();
                            dateController.clear();
                            responsableController.clear();
                            montantController.clear();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber[400]!,
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            submitButton,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          lieuController.clear();
                          dateController.clear();
                          responsableController.clear();
                          montantController.clear();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey[400]!,
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            "Réinitialiser",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          top: 110,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.subvId != null
                ? SizedBox(
                    height: 30,
                    width: 30,
                    child: FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.money_off,
                        size: 20,
                      ),
                      onPressed: () async {
                        UtilsBehavior.showCircularIndicator(context);
                        await dbHelper!.delete(widget.subvId!);
                        UtilsBehavior.hideCircularIndocator(context);
                        Navigator.of(context).pop(true);
                        lieuController.clear();
                        dateController.clear();
                        responsableController.clear();
                        montantController.clear();
                      },
                    ),
                  )
                : SizedBox(
                    height: 1,
                  ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
