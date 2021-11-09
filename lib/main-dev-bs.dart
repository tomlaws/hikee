// flutter run -t lib/main-dev-bs.dart
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:hikee/main.dart';

void main() {
  FlavorConfig(
    name: "DEVELOP",
    variables: {
      "API_ENDPOINT": "http://10.0.2.2:3000/",
    },
  );
  runApp(MyApp());
}