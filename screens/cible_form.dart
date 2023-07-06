// ignore_for_file: unused_import, must_be_immutable, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:ciblesmionjo/models/cible_model.dart';
import 'package:ciblesmionjo/models/commune_model.dart';
import 'package:ciblesmionjo/models/district_model.dart';
import 'package:ciblesmionjo/models/region_model.dart';
import 'package:ciblesmionjo/services/authentication_controller.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:basic_utils/basic_utils.dart';

class CibleForm extends StatefulWidget {
  int? cibleId;
  String? cibleFokontany;
  String? cibleNom;
  String? ciblePrenoms;
  String? cibleSexe;
  String? cibleSituation;
  String? cibleAges;
  String? cibleCin;
  String? cibleDateCin;
  String? cibleContact;
  String? cibleCategorie;
  String? cibleFonction;
  bool? cibleUpdate;

  CibleForm({
    this.cibleId,
    this.cibleFokontany,
    this.cibleNom,
    this.ciblePrenoms,
    this.cibleSexe,
    this.cibleSituation,
    this.cibleAges,
    this.cibleCin,
    this.cibleDateCin,
    this.cibleContact,
    this.cibleCategorie,
    this.cibleFonction,
    this.cibleUpdate,
  });

  @override
  State<CibleForm> createState() => _CibleFormState();
}

class _CibleFormState extends State<CibleForm> {
  static const _storage = FlutterSecureStorage();
  DBHelper? dbHelper;
  String regionStr = '';
  late Future<List<CibleModel>> cibleList;

  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final prenomsController = TextEditingController();
  final agesController = TextEditingController();
  final localiteController = TextEditingController();
  final cinController = TextEditingController();
  final dateCinController = TextEditingController();
  final contactController = TextEditingController();
  final fonctionController = TextEditingController();

  int? id_region;
  int? id_district;
  int? id_commune;
  List<int> cInfos = [];
  List<Commune> _dataCommuneList = [];
  List<Commune> _dataCommuneListSelected = [];
  List<District> _dataDistrictList = [];

  final List<String> sexeItems = [
    'H',
    'F',
  ];
  final List<String> situationItems = [
    'Célibataire',
    'Marié(e)',
    'Divorcé(e)',
    'Veuf(ve)',
  ];
  final List<String> categoriesItems = [
    'Ultra vulnérable',
    'Modérément vulnérable',
    'Vulnérable',
  ];
  String? sexeController;
  String? situationController;
  String? categorieController;
  String? communeController;
  String? districtController;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
    nomController.text = (widget.cibleNom ?? '');
    prenomsController.text = (widget.ciblePrenoms ?? '');
    agesController.text = (widget.cibleAges ?? '');
    localiteController.text = (widget.cibleFokontany ?? '');
    cinController.text = (widget.cibleCin ?? '');
    dateCinController.text = (widget.cibleDateCin ?? '');
    contactController.text = (widget.cibleContact ?? '');
    fonctionController.text = (widget.cibleFonction ?? '');
    sexeController = 'H';
    if (widget.cibleSexe != '' && widget.cibleSexe != null) {
      sexeController = widget.cibleSexe;
    }
    situationController = 'Célibataire';
    if (widget.cibleSituation != '' && widget.cibleSituation != null) {
      situationController = widget.cibleSituation;
    }
    categorieController = 'Vulnérable';
    if (widget.cibleCategorie != '' && widget.cibleCategorie != null) {
      categorieController = widget.cibleCategorie;
    }
  }

  loadData() async {
    cibleList = dbHelper!.getCibles();
    cInfos = await dbHelper!.getInformationsRegion();
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    regionStr = region.name!;
    List<Commune> communes = await dbHelper!.getCommuneList(0);
    List<District> districts = await dbHelper!.getDistrictList();
    setState(() {
      _dataCommuneList = communes;
      _dataDistrictList = districts;
    });
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
    if (widget.cibleUpdate == true) {
      appBarTitle =
          "METTRE A JOUR LA CIBLE : ${widget.cibleNom} ${widget.ciblePrenoms}";
      submitButton = "Mettre à jour la cible";
    } else {
      appBarTitle = "AJOUTER UNE CIBLE";
      submitButton = "Créer la cible";
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
                      "::: Informations Cible - REGION $regionStr :::",
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
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Text(
                                    "District",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 35,
                                width: 140,
                                padding: EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              items: _dataDistrictList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.id.toString(),
                                        child: Text(
                                          item.name.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                districtController = value.toString();
                                setState(() {
                                  _dataCommuneListSelected = _dataCommuneList
                                      .where((o) =>
                                          o.id_district ==
                                          int.parse(
                                              districtController.toString()))
                                      .toList();
                                });
                              },
                              onSaved: (value) {
                                districtController = value.toString();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Sélectionner le district de la cible !';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Text(
                                    "Commune",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 35,
                                width: 140,
                                padding: EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              items: _dataCommuneListSelected
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.id.toString(),
                                        child: Text(
                                          item.name.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                communeController = value.toString();
                              },
                              onSaved: (value) {
                                communeController = value.toString();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Sélectionner la commune de la cible !';
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
                              // initialValue: widget.cibleNom ?? '',
                              controller: nomController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Nom'),
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
                                  return 'Entrer le nom de la personne cible !';
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
                              controller: prenomsController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Prénoms'),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
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
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              value: sexeController,
                              isExpanded: true,
                              hint: const Text(
                                'Sexe',
                                style: TextStyle(fontSize: 14),
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 35,
                                width: 140,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              items: sexeItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                sexeController = value.toString();
                              },
                              onSaved: (value) {
                                sexeController = value.toString();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Sélectionner le sexe de la cible !';
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              controller: agesController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Ages'),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
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
                              controller: localiteController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Localité (Fokontany)'),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "::: Situation Cible :::",
                      textAlign: TextAlign.left,
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
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              isExpanded: true,
                              value: situationController,
                              hint: const Text(
                                'Situation',
                                style: TextStyle(fontSize: 14),
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 35,
                                width: 140,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              items: situationItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                situationController = value.toString();
                              },
                              onSaved: (value) {
                                situationController = value.toString();
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              isExpanded: true,
                              value: categorieController,
                              hint: const Text(
                                'Catégorie',
                                style: TextStyle(fontSize: 14),
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 35,
                                width: 140,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              items: categoriesItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                categorieController = value.toString();
                              },
                              onSaved: (value) {
                                categorieController = value.toString();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Sélectionner une catégorie pour la cible !';
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              controller: cinController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'CIN'),
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
                                  return 'Entrer le numéro CIN de la personne cible !';
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
                              controller: dateCinController,
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
                                      TextSpan(text: 'Date de délivrance'),
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
                                    dateCinController.text = formattedDate;
                                  });
                                } else {
                                  print("Date non sélectionnée");
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Entrer la date de délivrance de la CIN !';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "::: Contact Cible :::",
                      textAlign: TextAlign.left,
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
                              controller: contactController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Contact'),
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
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                                // Add more formatters as per your requirement
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Entrer le contact (téléphone) de la personne cible !';
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
                              controller: fonctionController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                fillColor: Colors.white,
                                filled: true,
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Fonction'),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
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
                            if (widget.cibleUpdate == true) {
                              dbHelper!.update(
                                CibleModel(
                                  id: widget.cibleId,
                                  id_region: cInfos[0],
                                  id_district:
                                      int.parse(districtController.toString()),
                                  id_commune:
                                      int.parse(communeController.toString()),
                                  fokontany: localiteController.text
                                      .trim()
                                      .toUpperCase(),
                                  nom: nomController.text.trim().toUpperCase(),
                                  prenoms: capitalizeTitle(
                                      prenomsController.text.trim()),
                                  sexe: sexeController,
                                  ages: agesController.text,
                                  situation: situationController,
                                  cin: cinController.text.trim(),
                                  date_cin: dateCinController.text,
                                  contact: contactController.text.trim(),
                                  categorie: categorieController,
                                  fonction: fonctionController.text
                                      .trim()
                                      .toUpperCase(),
                                ),
                              );
                            } else {
                              dbHelper!.insert(
                                CibleModel(
                                  id_region: cInfos[0],
                                  id_district:
                                      int.parse(districtController.toString()),
                                  id_commune:
                                      int.parse(communeController.toString()),
                                  fokontany: localiteController.text
                                      .trim()
                                      .toUpperCase(),
                                  nom: nomController.text.trim().toUpperCase(),
                                  prenoms: capitalizeTitle(
                                      prenomsController.text.trim()),
                                  sexe: sexeController,
                                  ages: agesController.text,
                                  situation: situationController,
                                  cin: cinController.text.trim(),
                                  date_cin: dateCinController.text,
                                  contact: contactController.text.trim(),
                                  categorie: categorieController,
                                  fonction: fonctionController.text
                                      .trim()
                                      .toUpperCase(),
                                ),
                              );
                            }
                            Navigator.of(context).pop(true);
                            nomController.clear();
                            prenomsController.clear();
                            agesController.clear();
                            localiteController.clear();
                            cinController.clear();
                            dateCinController.clear();
                            contactController.clear();
                            fonctionController.clear();
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
                          nomController.clear();
                          prenomsController.clear();
                          agesController.clear();
                          localiteController.clear();
                          cinController.clear();
                          dateCinController.clear();
                          contactController.clear();
                          fonctionController.clear();
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
            widget.cibleId != null
                ? SizedBox(
                    height: 30,
                    width: 30,
                    child: FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.person_remove,
                        size: 20,
                      ),
                      onPressed: () async {
                        UtilsBehavior.showCircularIndicator(context);
                        await dbHelper!.delete(widget.cibleId!);
                        UtilsBehavior.hideCircularIndocator(context);
                        Navigator.of(context).pop(true);
                        nomController.clear();
                        prenomsController.clear();
                        agesController.clear();
                        localiteController.clear();
                        cinController.clear();
                        dateCinController.clear();
                        contactController.clear();
                        fonctionController.clear();
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
