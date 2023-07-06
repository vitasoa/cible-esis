import 'package:ciblesmionjo/models/cible_model_paiement.dart';
import 'package:ciblesmionjo/models/commune_model.dart';
import 'package:ciblesmionjo/models/district_model.dart';
import 'package:ciblesmionjo/models/region_model.dart';
import 'package:ciblesmionjo/services/odoo_handler.dart';
import 'package:ciblesmionjo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class OdooServices {
  static final OdooClient _orpc = OdooClient(ConstantSise.odooHost);
  static final OdooServices _instance = OdooServices._internal();
  static OdooServices get instance => _instance;

  factory OdooServices() {
    return _instance;
  }

  OdooServices._internal();

  Future<bool> checkSession() async {
    try {
      await _orpc.checkSession();
      debugPrint("Session OK");
      return true;
    } catch (e) {
      debugPrint("Session NOT OK");
      return false;
    }
  }

  Future<bool> login() async {
    try {
      var session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      debugPrint(session.toString());
      debugPrint('Authenticated');
      return true;
    } on OdooException catch (_) {
      _orpc.close();
      debugPrint(_.toString());
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<Region>> getRegionsList() async {
    try {
      await _orpc.authenticate(ConstantSise.odooDb, ConstantSise.odooLogin,
          ConstantSise.odooPassword);
      var data = OdooHelper(
        model: Region.model,
        method: 'search_read',
        fields: Region.fields,
      );
      var res = await _orpc.callKw(data.toJson());
      return Region.fromJsonArray(res);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<CibleModelPaiement>> getCiblesList() async {
    try {
      await _orpc.authenticate(ConstantSise.odooDb, ConstantSise.odooLogin,
          ConstantSise.odooPassword);
      // var data = OdooHelper(
      //   model: CibleModelPaiement.model,
      //   method: 'search_read',
      //   fields: CibleModelPaiement.fields,
      // );
      // var res = await _orpc.callKw(data.toJson());

      var res = await _orpc.callKw({
        'model': CibleModelPaiement.model,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['eligible', '=', 'OUI']
          ],
          'fields': CibleModelPaiement.fields,
        },
      });

      return CibleModelPaiement.fromJsonArray(res);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<District>> getDistrictsList() async {
    try {
      await _orpc.authenticate(ConstantSise.odooDb, ConstantSise.odooLogin,
          ConstantSise.odooPassword);
      var data = OdooHelper(
        model: District.model,
        method: 'search_read',
        fields: District.fields,
      );
      var res = await _orpc.callKw(data.toJson());
      return District.fromJsonArray(res);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Commune>> getCommunesList() async {
    try {
      await _orpc.authenticate(ConstantSise.odooDb, ConstantSise.odooLogin,
          ConstantSise.odooPassword);
      var data = OdooHelper(
        model: Commune.model,
        method: 'search_read',
        fields: Commune.fields,
      );
      var res = await _orpc.callKw(data.toJson());
      return Commune.fromJsonArray(res);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
