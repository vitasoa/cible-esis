// ignore_for_file: file_names, avoid_print, await_only_futures, equal_keys_in_map, unused_local_variable, unused_field, non_constant_identifier_names
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/services/odoo_handler.dart';
import 'package:ciblesmionjo/utils/constants.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class SynchronizeController {
  static final OdooClient _orpc = OdooClient(ConstantSise.odooHost);
  static const _storage = FlutterSecureStorage();

  Future<bool> checkInternetConnectivity() async {
    String url = ConstantSise.odooHost;
    String cleanedUrl = url.replaceFirst(RegExp('^https?://'), '');
    var clearUrl = Uri.http(cleanedUrl);
    bool connected = false;
    try {
      final response = await http
          .get(
            clearUrl,
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        connected = true;
      } else {
        connected = false;
      }
    } catch (e) {
      connected = false;
    }

    return connected;
  }

  Future<int> searchOdooFunction(String fonction) async {
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      var data = OdooHelper(
        model: 'a.sise.fonctions.beneficiaire',
        method: 'search_read',
        fields: ['id', '__last_update', 'name'],
        domain: [
          ['name', '=', fonction.trim()]
        ],
      );
      var res = await _orpc.callKw(data.toJson());
      if (res.length != 0) {
        return int.parse(res[0]['id'].toString());
      }
      return 0;
    } catch (e) {
      debugPrint("ERROR: $e");
      return 0;
    }
  }

  Future<int> searchOdooSubvention(String? date_sub, String? lieu,
      String? nom_responsable, String? montant_beneficiaire) async {
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      var data = OdooHelper(
        model: 'a.sise.subvention.3a',
        method: 'search_read',
        fields: [
          'id',
          '__last_update',
          'name',
          'date_sub',
          'lieu',
          'nom_responsable',
          'montant_beneficiaire'
        ],
        domain: [
          ['date_sub', '=', date_sub!.trim()],
          ['lieu', '=', lieu!.trim()],
          ['nom_responsable', '=', nom_responsable!.trim()],
          ['montant_beneficiaire', '=', montant_beneficiaire!.trim()]
        ],
      );
      var res = await _orpc.callKw(data.toJson());
      if (res.length != 0) {
        return int.parse(res[0]['id'].toString());
      }
      return 0;
    } catch (e) {
      debugPrint("ERROR: $e");
      return 0;
    }
  }

  Future<int> createSubventionOdoo(String? date_sub, String? lieu,
      String? nom_responsable, String? montant_beneficiaire) async {
    int SubvOdooId = 0;
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      int SubvOdooId = await _orpc.callKw({
        'model': 'a.sise.subvention.3a',
        'method': 'create',
        'args': [
          {
            'date_sub': date_sub.toString().trim(),
            'lieu': lieu.toString().toUpperCase().trim(),
            'nom_responsable': nom_responsable.toString().toUpperCase().trim(),
            'montant_beneficiaire': montant_beneficiaire.toString().trim(),
            'type_groupe': 'GE'
          },
        ],
        'kwargs': {},
      });
      return SubvOdooId;
    } catch (e) {
      debugPrint("ERROR: $e");
      return 0;
    }
  }

  Future<int> searchOdooCible(String cin, int idCommune) async {
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      var data = OdooHelper(
        model: 'a.sise.membresgrp',
        method: 'search_read',
        fields: ['id', '__last_update', 'name', 'cin', 'id_commune'],
        domain: [
          ['cin', '=', cin.trim()],
          ['id_commune', '=', idCommune]
        ],
      );
      var res = await _orpc.callKw(data.toJson());
      if (res.length != 0) {
        return int.parse(res[0]['id'].toString());
      }
      return 0;
    } catch (e) {
      debugPrint("ERROR: $e");
      return 0;
    }
  }

  Future<int> createCibleOdoo(
      int idRegion,
      int idDistrict,
      int idCommune,
      String? fokontany,
      String nom,
      String? prenoms,
      String? sexe,
      String? ages,
      String? situation,
      String? cin,
      String? dateCin,
      String? contact,
      String? categorie,
      int? idFonction) async {
    int memberGrpOdooId = 0;
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      int memberGrpOdooId = await _orpc.callKw({
        'model': 'a.sise.membresgrp',
        'method': 'create',
        'args': [
          {
            'id_region': idRegion,
            'id_district': idDistrict,
            'id_commune': idCommune,
            'fokontany': fokontany.toString().trim(),
            'nom': nom.toString().trim(),
            'prenoms': prenoms.toString().trim(),
            'sexe': sexe,
            'situation': situation,
            'ages': ages,
            'cin': cin.toString().trim(),
            'date_cin': dateCin.toString().trim(),
            'contact': contact.toString().trim(),
            'categorie': categorie,
            'id_fonction': idFonction
          },
        ],
        'kwargs': {},
      });
      return memberGrpOdooId;
    } catch (e) {
      debugPrint("ERROR: $e");
      return 0;
    }
  }

  Future<int> idFunction(String fonctOdoo) async {
    int fonctId = 0;
    if (fonctOdoo != '') {
      fonctId = await searchOdooFunction(fonctOdoo);
      if (fonctId != 0) {
        return fonctId;
      } else {
        var fonctId = await _orpc.callKw({
          'model': 'a.sise.fonctions.beneficiaire',
          'method': 'create',
          'args': [
            {'name': fonctOdoo.trim()},
          ],
          'kwargs': {},
        });
        return fonctId;
      }
    }
    return fonctId;
  }

  Future<int> sendSynchroniseData() async {
    bool connected = await checkInternetConnectivity();
    if (connected) {
      debugPrint('Device connected');
      /*** ENVOYER CIBLES ***/
      var cInfos = await DBHelper().getInformationsRegion();
      int idRegion = int.parse(cInfos[0].toString());
      var listCibles = await DBHelper().getCibles();
      if (listCibles.isNotEmpty) {
        for (int ii = 0; ii < listCibles.length; ii++) {
          String? fonction = listCibles[ii].fonction;
          String fonctOdoo = fonction!.trim();
          int idF = await idFunction(fonctOdoo);
          int cibleOdoo = await searchOdooCible(
              listCibles[ii].cin!, listCibles[ii].id_commune!);
          if (cibleOdoo == 0) {
            int idMember = await createCibleOdoo(
                idRegion,
                int.parse(listCibles[ii].id_district.toString()),
                int.parse(listCibles[ii].id_commune.toString()),
                listCibles[ii].fokontany!,
                listCibles[ii].nom!,
                listCibles[ii].prenoms!,
                listCibles[ii].sexe!,
                listCibles[ii].ages!,
                listCibles[ii].situation!,
                listCibles[ii].cin!,
                listCibles[ii].date_cin!,
                listCibles[ii].contact!,
                listCibles[ii].categorie!,
                idF);
          }
        }
      }
      /*** ENVOYER SUBVENTIONS ***/
      var listSubventions = await DBHelper().getSubventions();
      if (listSubventions.isNotEmpty) {
        for (int ij = 0; ij < listSubventions.length; ij++) {
          int subventionOdoo = await searchOdooSubvention(
            listSubventions[ij].date_sub,
            listSubventions[ij].lieu,
            listSubventions[ij].nom_responsable,
            listSubventions[ij].montant_beneficiaire,
          );
          if (subventionOdoo == 0) {
            int idMember = await createSubventionOdoo(
              listSubventions[ij].date_sub,
              listSubventions[ij].lieu,
              listSubventions[ij].nom_responsable,
              listSubventions[ij].montant_beneficiaire,
            );
          }
        }
      }
      /*** ENVOYER SUBVENTIONS+CIBLES+PAIEMENTS ***/
      var listPaiements = await DBHelper().getCiblesPaiement();
      if (listPaiements.isNotEmpty) {
        List<Map<String, String>> lCibles = [];
        for (int ik = 0; ik < listPaiements.length; ik++) {
          /*** TESTER LES CIBLES AVEC DES SUBVENTIONS ***/
          if (listPaiements[ik].date_paiement != null &&
              listPaiements[ik].montant_subvention != null &&
              listPaiements[ik].id_subvention != null) {
            /** PRENDRE SUBVENTION VENANT D'ODOO **/
            var subvDet = await DBHelper().getSubventionDetailsById(
                int.parse(listPaiements[ik].id_subvention.toString()));
            int subventionOdoo = await searchOdooSubvention(
              subvDet!.date_sub.toString().trim(),
              subvDet.lieu,
              listPaiements[ik].nom_responsable.toString().trim(),
              listPaiements[ik].montant_subvention.toString().trim(),
            );
            lCibles.add(UtilsBehavior.createJsonObject(
                subventionOdoo.toString(), listPaiements[ik].id.toString()));
            /** SIMPLE : INSERT INTO MANY2MANY TABLE **/
          }
        }
        /** GROUPER PAR SUBVENTION **/
        List<Map<String, dynamic>> cJsonList =
            UtilsBehavior.groupJsonList(lCibles, 'sub_id');
        /** METTRE A JOUR CHAQUE SUBVENTION ODOO **/
        for (int il = 0; il < cJsonList.length; il++) {
          List cibleIds = [];
          for (int im = 0; im < cJsonList[il]['data'].length; im++) {
            cibleIds.add(cJsonList[il]['data'][im]['cible_id']);
          }
          if (cibleIds.isNotEmpty) {
            int subdId = await updateCibleToSubvention(
                int.parse(cJsonList[il]['sub_id'].toString()), cibleIds);
          }
        }
      }
      return 1;
    }
    return 0;
  }

  Future<int> createSubventionMembreOdoo(int? date_sub, String? lieu,
      String? nom_responsable, String? montant_beneficiaire) async {
    int SubvOdooId = 0;
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      int SubvOdooId = await _orpc.callKw({
        'model': 'a.sise.subvention.3a',
        'method': 'create',
        'args': [
          {
            'date_sub': date_sub.toString().trim(),
            'lieu': lieu.toString().toUpperCase().trim(),
            'nom_responsable': nom_responsable.toString().toUpperCase().trim(),
            'montant_beneficiaire': montant_beneficiaire.toString().trim(),
            'type_groupe': 'GE'
          },
        ],
        'kwargs': {},
      });
      return SubvOdooId;
    } catch (e) {
      debugPrint("ERROR: $e");
      return 0;
    }
  }

  Future<int> updateCibleToSubvention(int idSubvention, List idCibles) async {
    var res = 0;
    try {
      await _orpc.authenticate(ConstantSise.odooDb, ConstantSise.odooLogin,
          ConstantSise.odooPassword);
      await _orpc.callKw({
        'model': 'a.sise.subvention.3a',
        'method': 'write',
        'args': [
          [idSubvention],
          {
            'members_grps': [
              [6, false, idCibles],
            ],
          },
        ],
        'kwargs': {},
      });
      res = 1;
    } catch (e) {
      debugPrint("ERROR: $e");
    }
    return res;
  }
}
