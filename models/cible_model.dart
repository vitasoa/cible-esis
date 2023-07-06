// ignore_for_file: non_constant_identifier_names

class CibleModel {
  final int? id;
  int? id_commune;
  String? commune;
  int? id_district;
  String? district;
  int? id_region;
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

  CibleModel(
      {this.id,
      this.id_region,
      this.id_district,
      this.district,
      this.id_commune,
      this.commune,
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

  CibleModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        id_region = res['id_region'],
        id_district = res['id_district'],
        district = res['district'],
        id_commune = res['id_commune'],
        commune = res['commune'],
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
}
