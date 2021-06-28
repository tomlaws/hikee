import 'package:flutter/widgets.dart';

class PanelPosition extends ChangeNotifier {
  double _position = 0.0;

  double get position => _position;

  void update(double position) {
    this._position = position;
    notifyListeners();
  }
}
