// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

class Subvention {
  int? id;
  String? date_sub;
  String? lieu;
  String? nom_responsable;
  String? montant_beneficiaire;

  static const String model = 'a.sise.subvention.3a';
  static const List<String> fields = [
    'id',
    '__last_update',
    'name',
    'date_sub',
    'lieu',
    'nom_responsable',
    'montant_beneficiaire'
  ];

  Subvention(
      {this.id,
      this.date_sub,
      this.lieu,
      this.nom_responsable,
      this.montant_beneficiaire});

  Subvention.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        date_sub = res['date_sub'],
        lieu = res['lieu'],
        nom_responsable = res['nom_responsable'],
        montant_beneficiaire = res['montant_beneficiaire'];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "date_sub": date_sub,
      "lieu": lieu,
      "nom_responsable": nom_responsable,
      "montant_beneficiaire": montant_beneficiaire
    };
  }

  Subvention.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date_sub = json['date_sub'],
        lieu = json['lieu'],
        nom_responsable = json['nom_responsable'],
        montant_beneficiaire = json['montant_beneficiaire'];

  static fromJsonArray(List json) {
    return json.map((e) => Subvention.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_sub': date_sub,
      'lieu': lieu,
      'nom_responsable': nom_responsable,
      'montant_beneficiaire': montant_beneficiaire,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
