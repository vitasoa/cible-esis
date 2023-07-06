// ignore_for_file: file_names

import 'dart:convert';

class Region {
  int? id;
  String? name;
  String? code;

  static const String model = 'a.sise.regions';
  static const List<String> fields = ['id', '__last_update', 'name', 'code'];

  Region({required this.id, required this.name, this.code});

  Region.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        code = res['code'];

  Map<String, Object?> toMap() {
    return {"id": id, "name": name, "code": code};
  }

  Region.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        code = json['code'];

  static fromJsonArray(List json) {
    return json.map((e) => Region.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
