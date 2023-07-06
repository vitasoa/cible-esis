// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:ciblesmionjo/models/cible_model.dart';
import 'package:ciblesmionjo/models/cible_model_paiement.dart';
import 'package:ciblesmionjo/models/commune_model.dart';
import 'package:ciblesmionjo/models/district_model.dart';
import 'package:ciblesmionjo/models/region_model.dart';
import 'package:ciblesmionjo/models/subvention_model.dart';
import 'package:ciblesmionjo/services/odoo_service.dart';
import 'package:ciblesmionjo/services/synchronize_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

const String ciblesTable = 'cibles';
const String ciblesPaiementTable = 'cibles_paiement';
const String subventionsTable = 'subventions';
const String regionsTable = 'regions';
const String districtsTable = 'districts';
const String communesTable = 'communes';

class DBHelper {
  static Database? _db;

  final _storage = const FlutterSecureStorage();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDataBase();
    return null;
  }

  initDataBase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cibles.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreateDataBase);
    return db;
  }

  _onCreateDataBase(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $subventionsTable (
            id INTEGER PRIMARY KEY,
            date_sub TEXT,
            lieu TEXT,
            nom_responsable TEXT,
            montant_beneficiaire TEXT
          )
        ''');
    await db.execute('''
          CREATE TABLE $regionsTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            code TEXT
          )
        ''');
    await db.execute('''
          CREATE TABLE $districtsTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            code TEXT,
            id_region INTEGER,
            FOREIGN KEY (id_region) REFERENCES $regionsTable(id)
          )
        ''');
    await db.execute('''
          CREATE TABLE $communesTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            code TEXT,
            password TEXT,
            id_district INTEGER,
            FOREIGN KEY (id_district) REFERENCES $districtsTable(id)
          )
        ''');
    await db.execute(
      '''CREATE TABLE $ciblesTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            id_commune INTEGER,
            id_district INTEGER,
            id_region INTEGER,
            fokontany TEXT,
            nom TEXT,
            prenoms TEXT,
            sexe TEXT,
            situation TEXT,
            ages TEXT,
            cin TEXT,
            date_cin TEXT,
            contact TEXT,
            categorie TEXT,
            fonction TEXT,
            FOREIGN KEY (id_commune) REFERENCES $communesTable(id),
            FOREIGN KEY (id_district) REFERENCES $districtsTable(id),
            FOREIGN KEY (id_region) REFERENCES $regionsTable(id))''',
    );
    await db.execute(
      '''CREATE TABLE $ciblesPaiementTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            id_commune INTEGER,
            id_district INTEGER,
            id_region INTEGER,
            id_subvention INTEGER,
            montant_subvention TEXT,
            date_paiement TEXT,
            fokontany TEXT,
            nom TEXT,
            prenoms TEXT,
            sexe TEXT,
            situation TEXT,
            ages TEXT,
            cin TEXT,
            date_cin TEXT,
            contact TEXT,
            categorie TEXT,
            fonction TEXT,
            FOREIGN KEY (id_commune) REFERENCES $communesTable(id),
            FOREIGN KEY (id_district) REFERENCES $districtsTable(id),
            FOREIGN KEY (id_region) REFERENCES $regionsTable(id),
            FOREIGN KEY (id_subvention) REFERENCES $subventionsTable(id))''',
    );
  }

  Future<CibleModel> insert(CibleModel cibleModel) async {
    var dbHelper = await db;
    await dbHelper?.insert('cibles', cibleModel.toMap());
    return cibleModel;
  }

  Future<Commune> getCommuneById(int idCommune) async {
    await db;
    var QueryResult =
        await _db!.rawQuery("SELECT * FROM $communesTable WHERE id=$idCommune");
    return Commune.fromJsonLocal(QueryResult[0]);
  }

  Future<List<Commune>> getCommuneList(int? idDistrict) async {
    await db;
    final result = await _db!.query(communesTable);
    List<Commune> list = result.map((c) => Commune.fromJsonLocal(c)).toList();
    return list;
  }

  Future<List<District>> getDistrictList() async {
    await db;
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    final result = await _db!
        .rawQuery("SELECT * FROM $districtsTable WHERE id_region=${region.id}");
    List<District> list = result.map((c) => District.fromJsonLocal(c)).toList();
    return list;
  }

  Future<List<CibleModelPaiement>> getCiblesPayes() async {
    await db;
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));

    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery("""
SELECT 
cibles_paiement.id,
cibles_paiement.id_region, 
cibles_paiement.id_district, 
districts.name AS district, 
cibles_paiement.id_commune, 
communes.name AS commune, 
cibles_paiement.id_subvention, 
subventions.date_sub AS subvention, 
cibles_paiement.date_paiement,
cibles_paiement.montant_subvention,
subventions.nom_responsable,
cibles_paiement.fokontany, 
cibles_paiement.nom, 
cibles_paiement.prenoms, 
cibles_paiement.sexe, 
cibles_paiement.situation, 
cibles_paiement.ages, 
cibles_paiement.cin, 
cibles_paiement.date_cin, 
cibles_paiement.contact, 
cibles_paiement.categorie, 
cibles_paiement.fonction  
FROM cibles_paiement 
INNER JOIN communes ON communes.id = cibles_paiement.id_commune 
INNER JOIN districts ON districts.id = cibles_paiement.id_district 
LEFT JOIN subventions ON subventions.id = cibles_paiement.id_subvention 
WHERE cibles_paiement.id_region=${region.id} AND cibles_paiement.date_paiement IS NOT NULL ORDER BY cibles_paiement.cin ASC""");
    return QueryResult.map((e) => CibleModelPaiement.fromMap(e)).toList();
  }

  Future<List<CibleModelPaiement>> getCiblesPayesCin(String? cin) async {
    await db;

    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));

    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery("""
SELECT 
cibles_paiement.id,
cibles_paiement.id_region, 
cibles_paiement.id_district, 
districts.name AS district, 
cibles_paiement.id_commune, 
communes.name AS commune, 
cibles_paiement.id_subvention, 
subventions.date_sub AS subvention, 
cibles_paiement.date_paiement,
cibles_paiement.montant_subvention,
subventions.nom_responsable,
cibles_paiement.fokontany, 
cibles_paiement.nom, 
cibles_paiement.prenoms, 
cibles_paiement.sexe, 
cibles_paiement.situation, 
cibles_paiement.ages, 
cibles_paiement.cin, 
cibles_paiement.date_cin, 
cibles_paiement.contact, 
cibles_paiement.categorie, 
cibles_paiement.fonction  
FROM cibles_paiement 
INNER JOIN communes ON communes.id = cibles_paiement.id_commune 
INNER JOIN districts ON districts.id = cibles_paiement.id_district 
LEFT JOIN subventions ON subventions.id = cibles_paiement.id_subvention 
WHERE cibles_paiement.id_region=${region.id} AND cibles_paiement.date_paiement IS NOT NULL AND cibles_paiement.cin LIKE '%$cin%' ORDER BY cibles_paiement.cin ASC""");
    return QueryResult.map((e) => CibleModelPaiement.fromMap(e)).toList();
  }

  Future<List<CibleModelPaiement>> getCiblesPaiement() async {
    await db;
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));

    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery("""
SELECT 
cibles_paiement.id,
cibles_paiement.id_region, 
cibles_paiement.id_district, 
districts.name AS district, 
cibles_paiement.id_commune, 
communes.name AS commune, 
cibles_paiement.id_subvention, 
subventions.date_sub AS subvention, 
cibles_paiement.date_paiement,
cibles_paiement.montant_subvention,
subventions.nom_responsable,
cibles_paiement.fokontany, 
cibles_paiement.nom, 
cibles_paiement.prenoms, 
cibles_paiement.sexe, 
cibles_paiement.situation, 
cibles_paiement.ages, 
cibles_paiement.cin, 
cibles_paiement.date_cin, 
cibles_paiement.contact, 
cibles_paiement.categorie, 
cibles_paiement.fonction  
FROM cibles_paiement 
INNER JOIN communes ON communes.id = cibles_paiement.id_commune 
INNER JOIN districts ON districts.id = cibles_paiement.id_district 
LEFT JOIN subventions ON subventions.id = cibles_paiement.id_subvention 
WHERE cibles_paiement.id_region=${region.id} AND cibles_paiement.date_paiement IS NULL ORDER BY cibles_paiement.cin ASC""");
    return QueryResult.map((e) => CibleModelPaiement.fromMap(e)).toList();
  }

  Future<List<CibleModelPaiement>> getCiblesPaiementCin(String? cin) async {
    await db;

    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));

    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery("""
SELECT 
cibles_paiement.id,
cibles_paiement.id_region, 
cibles_paiement.id_district, 
districts.name AS district, 
cibles_paiement.id_commune, 
communes.name AS commune, 
cibles_paiement.id_subvention, 
subventions.date_sub AS subvention, 
cibles_paiement.date_paiement,
cibles_paiement.montant_subvention,
subventions.nom_responsable,
cibles_paiement.fokontany, 
cibles_paiement.nom, 
cibles_paiement.prenoms, 
cibles_paiement.sexe, 
cibles_paiement.situation, 
cibles_paiement.ages, 
cibles_paiement.cin, 
cibles_paiement.date_cin, 
cibles_paiement.contact, 
cibles_paiement.categorie, 
cibles_paiement.fonction  
FROM cibles_paiement 
INNER JOIN communes ON communes.id = cibles_paiement.id_commune 
INNER JOIN districts ON districts.id = cibles_paiement.id_district 
LEFT JOIN subventions ON subventions.id = cibles_paiement.id_subvention 
WHERE cibles_paiement.id_region=${region.id} AND cibles_paiement.date_paiement IS NULL AND cibles_paiement.cin LIKE '%$cin%' ORDER BY cibles_paiement.cin ASC""");
    return QueryResult.map((e) => CibleModelPaiement.fromMap(e)).toList();
  }

  Future<List<CibleModel>> getCibles() async {
    await db;

    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));

    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery("""
SELECT 
cibles.id,
cibles.id_region, 
cibles.id_district, 
districts.name AS district, 
cibles.id_commune, 
communes.name AS commune, 
cibles.fokontany, 
cibles.nom, 
cibles.prenoms, 
cibles.sexe, 
cibles.situation, 
cibles.ages, 
cibles.cin, 
cibles.date_cin, 
cibles.contact, 
cibles.categorie, 
cibles.fonction  
FROM cibles 
INNER JOIN communes ON communes.id = cibles.id_commune 
INNER JOIN districts ON districts.id = cibles.id_district 
WHERE cibles.id_region=${region.id} ORDER BY cibles.cin ASC""");
    return QueryResult.map((e) => CibleModel.fromMap(e)).toList();
  }

  Future<List<CibleModel>> getCiblesCin(String? cin) async {
    await db;

    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));

    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery("""
SELECT
cibles.id,
cibles.id_region, 
cibles.id_district, 
districts.name AS district, 
cibles.id_commune, 
communes.name AS commune, 
cibles.fokontany, 
cibles.nom, 
cibles.prenoms, 
cibles.sexe, 
cibles.situation, 
cibles.ages, 
cibles.cin, 
cibles.date_cin, 
cibles.contact, 
cibles.categorie, 
cibles.fonction  
FROM cibles 
INNER JOIN communes ON communes.id = cibles.id_commune 
INNER JOIN districts ON districts.id = cibles.id_district 
WHERE cibles.id_region=${region.id} AND cibles.cin LIKE '%$cin%' ORDER BY cibles.cin ASC""");
    return QueryResult.map((e) => CibleModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbHelper = await db;
    return await dbHelper!.delete('cibles', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(CibleModel cibleModel) async {
    var dbHelper = await db;
    return await dbHelper!.update('cibles', cibleModel.toMap(),
        where: 'id = ?', whereArgs: [cibleModel.id]);
  }

  Future<Subvention?> getLastSubventionDetails() async {
    await db;
    var QueryResult =
        await _db!.rawQuery("SELECT * FROM $subventionsTable ORDER BY id DESC");
    if (QueryResult.isNotEmpty) {
      return Subvention.fromJson(QueryResult[0]);
    } else {
      return null;
    }
  }

  Future<Subvention?> getSubventionDetailsById(int id) async {
    await db;
    var QueryResult = await _db!.rawQuery(
        "SELECT * FROM $subventionsTable WHERE id=$id ORDER BY id DESC");
    if (QueryResult.isNotEmpty) {
      return Subvention.fromJson(QueryResult[0]);
    } else {
      return null;
    }
  }

  Future<Subvention> insertSubv(Subvention subv) async {
    var dbHelper = await db;
    await dbHelper?.insert('subventions', subv.toMap());
    return subv;
  }

  Future<int> updateSubv(Subvention subv) async {
    var dbHelper = await db;
    return await dbHelper!.update('subventions', subv.toMap(),
        where: 'id = ?', whereArgs: [subv.id]);
  }

  Future<List<int>> getInformationsRegion() async {
    await db;
    int ge = 0;
    int gms = 0;
    int cible = 0;
    int subv = 0;
    int paiement = 0;
    int idDistrict = 0;
    int idRegion = 0;
    int idCommune = 0;

    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));

    var cibles = await _db!.rawQuery(
        """SELECT count(*) as nbrCibles FROM '$ciblesTable' WHERE id_region=${region.id}""");
    cible = int.parse(cibles[0]['nbrCibles'].toString());

    var ciblesGe = await _db!.rawQuery(
        """SELECT count(*) as nbrCiblesGe FROM '$ciblesTable' WHERE categorie !='Vulnérable' AND id_region=${region.id}""");
    ge = int.parse(ciblesGe[0]['nbrCiblesGe'].toString());

    var ciblesGms = await _db!.rawQuery(
        """SELECT count(*) as nbrCiblesGms FROM '$ciblesTable' WHERE (categorie is null or categorie='Vulnérable') AND id_region=${region.id}""");
    gms = int.parse(ciblesGms[0]['nbrCiblesGms'].toString());

    var subvCible = await _db!.rawQuery(
        """SELECT count(*) as nbrCiblesSubv FROM '$subventionsTable'""");
    subv = int.parse(subvCible[0]['nbrCiblesSubv'].toString());

    var paiementCible = await _db!.rawQuery(
        """SELECT count(*) as nbrCiblesPaiement FROM '$ciblesPaiementTable' WHERE id_region=${region.id} AND montant_subvention>0""");
    paiement = int.parse(paiementCible[0]['nbrCiblesPaiement'].toString());

    idRegion = int.parse(region.id.toString());

    return [idRegion, idDistrict, idCommune, cible, gms, ge, subv, paiement]
        .toList();
  }

  Future<int> synchroniseData() async {
    await db;

    bool connected = await SynchronizeController().checkInternetConnectivity();
    if (!connected) {
      return 0;
    }

    var oService = OdooServices.instance;

    List<Map> regions = await _db!.rawQuery('SELECT * FROM $regionsTable');
    List<Map> districts = await _db!.rawQuery('SELECT * FROM $districtsTable');
    List<Map> communes = await _db!.rawQuery('SELECT * FROM $communesTable');

    if (regions.isEmpty) {
      var regions = await oService.getRegionsList();
      for (int i = 0; i < regions.length; i++) {
        int intIdRegion = await _db!.insert(regionsTable, regions[i].toJson());
      }
    }

    if (districts.isEmpty) {
      var districts = await oService.getDistrictsList();
      for (int i = 0; i < districts.length; i++) {
        int intIdDistrict =
            await _db!.insert(districtsTable, districts[i].toJson());
      }
    }

    if (communes.isEmpty) {
      var communes = await oService.getCommunesList();
      for (int i = 0; i < communes.length; i++) {
        int intIdcommune =
            await _db!.insert(communesTable, communes[i].toJson());
      }
    } else {
      var communes = await oService.getCommunesList();
      for (int i = 0; i < communes.length; i++) {
        Commune commune = communes[i];
        var existCommune = await getCommuneExist(commune.code);
        if (existCommune) {
          await updateCommuneFromOdoo(commune.code, commune.password);
        } else {
          await _db!.insert(communesTable, communes[i].toJson());
        }
      }
    }
    return communes.length;
  }

  Future<bool> updateCommuneFromOdoo(String? code, String? password) async {
    if (code != null && password != null) {
      await _db!.update(
        communesTable,
        {'password': password},
        where: "code = ?",
        whereArgs: [code],
      );
    }
    return true;
  }

  Future<bool> getCommuneExist(code) async {
    final result = await _db!.query(
      communesTable,
      columns: ['id'],
      where: 'code = ?',
      whereArgs: [code],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> authenticate(String code) async {
    await db;
    var codeSplit = code.split("-");
    if (codeSplit.isEmpty || codeSplit.length <= 1) {
      return false;
    }
    String cc = codeSplit[0].toString().trim().toUpperCase();
    String cp = codeSplit[1].toString().trim().toUpperCase();
    try {
      String cc = codeSplit[0].toString().trim().toUpperCase();
      String cp = codeSplit[1].toString().trim().toUpperCase();
      List<Map<String, dynamic>> region = await _db!.rawQuery(
          "SELECT * FROM $regionsTable WHERE name='$cc' AND code='$cp'");
      if (region.isNotEmpty) {
        var dataRegion = Region.fromMap(region.first);
        await _storage.write(key: "region", value: dataRegion.toString());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<Subvention>> getSubventions() async {
    await db;
    var region =
        Region.fromJson(jsonDecode(await _storage.read(key: 'region') ?? ''));
    final List<Map<String, Object?>> QueryResult = await _db!
        .rawQuery("SELECT * FROM $subventionsTable ORDER BY date_sub DESC");
    return QueryResult.map((e) => Subvention.fromMap(e)).toList();
  }

  Future<int> getCiblesData() async {
    await db;

    bool connected = await SynchronizeController().checkInternetConnectivity();
    if (!connected) {
      return 0;
    }

    var oService = OdooServices.instance;

    List<Map> paiements =
        await _db!.rawQuery('SELECT * FROM $ciblesPaiementTable');

    var cibles = await oService.getCiblesList();
    if (paiements.isEmpty) {
      for (int i = 0; i < cibles.length; i++) {
        int intIdCible =
            await _db!.insert(ciblesPaiementTable, cibles[i].toMap());
      }
    }
    return cibles.length;
  }

  Future<int> updateCiblePaiementData(
      String? cin,
      String? idCommune,
      String? cibleId,
      String? dateSub,
      String? idSub,
      String? montantSub) async {
    var dbHelper = await db;
    int cId = int.parse(cibleId.toString());
    return await dbHelper!.update(
        ciblesPaiementTable,
        {
          'id_subvention': int.parse(idSub.toString()),
          'montant_subvention': montantSub,
          // 'date_paiement': dateSub
          'date_paiement':
              DateFormat('yMd').add_jm().format(DateTime.now()).toString()
        },
        where: 'id = ?',
        whereArgs: [cId]);
  }

  Future<int> updateCiblePaiementDataNull(String? cibleId) async {
    var dbHelper = await db;
    int cId = int.parse(cibleId.toString());
    return await dbHelper!.update(
        ciblesPaiementTable,
        {
          'id_subvention': null,
          'montant_subvention': null,
          'date_paiement': null
        },
        where: 'id = ?',
        whereArgs: [cId]);
  }

  Future<void> removeData() async {
    var dbHelper = await db;
    try {
      await _db!.rawQuery("DELETE FROM cibles_paiement");
      await _db!.rawQuery("DELETE FROM subventions");
    } catch (error) {
      throw Exception('DbBase.cleanDatabase: $error');
    }
  }

  Future<CibleModelPaiement?> getCiblePaiementDetails(String? qrCode) async {
    await db;
    var codeSplit = qrCode!.split("-");
    if (codeSplit.isEmpty || codeSplit.length <= 1) {
      return null;
    }
    String cc = codeSplit[0].toString().trim();
    String cp = codeSplit[1].toString().trim();
    var QueryResult = await _db!.rawQuery(
        "SELECT * FROM $ciblesPaiementTable WHERE cin='$cc' AND id_commune='$cp' ORDER BY id DESC");
    if (QueryResult.isNotEmpty) {
      return CibleModelPaiement.fromJsonSqlite(QueryResult[0]);
    } else {
      return null;
    }
  }
}
