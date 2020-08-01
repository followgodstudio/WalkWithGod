import 'package:flutter/foundation.dart';

class Platform {
  final int id;
  final String name;
  final String logoURL;

  Platform({
    @required this.id,
    @required this.name,
    @required this.logoURL,
  });
}
