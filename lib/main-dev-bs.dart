// flutter run -t lib/main-dev-bs.dart
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:hikees/main.dart';

void main() {
  FlavorConfig(
    name: "DEVELOP",
    variables: {
      "API_ENDPOINT": "http://192.168.50.248:3000/",
    },
  );
  runApp(MyApp());
}
