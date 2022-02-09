import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/location_dto.dart';

class LocationServiceRepository {
  static LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  Future<void> init(Map<dynamic, dynamic> params) async {
    SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> dispose() async {
    SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto);
  }
}
