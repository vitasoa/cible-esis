// ignore_for_file: file_names

class OdooHelper {
  final String model;
  final String method;
  final List<String> fields;
  bool kwargs;
  List<dynamic> args;
  bool binSize;
  List<List<dynamic>> domain;

  OdooHelper({
    required this.model,
    required this.method,
    required this.fields,
    this.args = const [],
    this.binSize = true,
    this.domain = const [],
    this.kwargs = true,
  });

  toJson() {
    return {
      'model': model,
      'method': method,
      'args': args,
      'kwargs': kwargs == false
          ? {}
          : {
              'context': {'bin_size': binSize},
              'domain': domain,
              'fields': fields,
            },
    };
  }
}
