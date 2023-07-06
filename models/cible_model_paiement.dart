// ignore_for_file: non_constant_identifier_names

class CibleModelPaiement {
  final int? id;
  int? id_commune;
  String? commune;
  int? id_district;
  String? district;
  int? id_region;
  int? id_subvention;
  String? subvention;
  String? montant_subvention;
  String? date_paiement;
  String? nom_responsable;
  String? fokontany;
  String? nom;
  String? prenoms;
  String? sexe;
  String? situation;
  String? ages;
  String? cin;
  String? date_cin;
  String? contact;
  String? categorie;
  String? fonction;

  static const String model = 'a.sise.membresgrp';
  static const List<String> fields = [
    'id',
    '__last_update',
    'id_region',
    'id_district',
    'id_commune',
    'fokontany',
    'nom',
    'prenoms',
    'sexe',
    'situation',
    'ages',
    'cin',
    'date_cin',
    'contact',
    'id_fonction',
    'categorie'
  ];

  CibleModelPaiement(
      {this.id,
      this.id_region,
      this.id_district,
      this.district,
      this.id_commune,
      this.commune,
      this.id_subvention,
      this.subvention,
      this.montant_subvention,
      this.date_paiement,
      this.nom_responsable,
      this.fokontany,
      this.nom,
      this.prenoms,
      this.sexe,
      this.situation,
      this.ages,
      this.cin,
      this.date_cin,
      this.contact,
      this.categorie,
      this.fonction});

  CibleModelPaiement.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        id_region = res['id_region'],
        id_district = res['id_district'],
        district = res['district'],
        id_commune = res['id_commune'],
        commune = res['commune'],
        id_subvention = res['id_subvention'],
        subvention = res['subvention'],
        montant_subvention = res['montant_subvention'],
        date_paiement = res['date_paiement'],
        nom_responsable = res['nom_responsable'],
        fokontany = res['fokontany'],
        nom = res['nom'],
        prenoms = res['prenoms'],
        sexe = res['sexe'],
        situation = res['situation'],
        ages = res['ages'],
        cin = res['cin'],
        date_cin = res['date_cin'],
        contact = res['contact'],
        categorie = res['categorie'],
        fonction = res['fonction'];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "id_region": id_region,
      "id_district": id_district,
      "id_commune": id_commune,
      "id_subvention": id_subvention,
      'montant_subvention': montant_subvention,
      'date_paiement': date_paiement,
      // 'nom_responsable': nom_responsable,
      "fokontany": fokontany,
      "nom": nom,
      "prenoms": prenoms,
      "sexe": sexe,
      "situation": situation,
      "ages": ages,
      "cin": cin,
      "date_cin": date_cin,
      "contact": contact,
      "categorie": categorie,
      "fonction": fonction
    };
  }

  CibleModelPaiement.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        id_region = json['id_region'][0],
        id_district = json['id_district'][0],
        id_commune = json['id_commune'][0],
        fokontany = json['fokontany'] != false ? json['fokontany'] : '',
        nom = json['nom'] != false ? json['nom'] : '',
        prenoms = json['prenoms'] != false ? json['prenoms'] : '',
        sexe = json['sexe'] != false ? json['sexe'] : '',
        situation = json['situation'] != false ? json['situation'] : '',
        ages = json['ages'].toString(),
        cin = json['cin'] != false ? json['cin'] : '',
        date_cin = json['date_cin'] != false ? json['date_cin'] : '',
        contact = json['contact'] != false ? json['contact'] : '',
        categorie = json['categorie'] != false ? json['categorie'] : '',
        fonction = json['id_fonction'] != false ? json['id_fonction'][1] : '';

  CibleModelPaiement.fromJsonSqlite(Map<String, dynamic> json)
      : id = json['id'],
        id_region = json['id_region'],
        id_district = json['id_district'],
        id_commune = json['id_commune'],
        id_subvention = json['id_commune'],
        montant_subvention = json['montant_subvention'],
        date_paiement = json['date_paiement'],
        fokontany = json['fokontany'],
        nom = json['nom'],
        prenoms = json['prenoms'],
        sexe = json['sexe'],
        situation = json['situation'],
        ages = json['ages'].toString(),
        cin = json['cin'],
        date_cin = json['date_cin'],
        contact = json['contact'],
        categorie = json['categorie'],
        fonction = json['fonction'];

  static fromJsonArray(List json) {
    return json.map((e) => CibleModelPaiement.fromJson(e)).toList();
  }
}
