import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/services/auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Auth extends ChangeNotifier {
  ValueNotifier<Token?> _token = ValueNotifier(null);

  bool get loggedIn => _token.value != null;

  final _storage = FlutterSecureStorage();
  AuthService get _authService => GetIt.I<AuthService>();

  Auth() {
    _token.addListener(_onTokenChanged);
    Future.wait([
      _storage.read(key: 'accessToken'),
      _storage.read(key: 'refreshToken')
    ]).then((tokens) {
      if (!tokens.contains(null))
        _token.value = Token(accessToken: tokens[0]!, refreshToken: tokens[1]!);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void dispose() {
    _token.removeListener(_onTokenChanged);
    _token.dispose();
    super.dispose();
  }

  void _onTokenChanged() {
    if (_token.value == null) {
      _storage.delete(key: 'accessToken');
      _storage.delete(key: 'refreshToken');
    } else {
      _storage.write(key: 'accessToken', value: _token.value!.accessToken);
      _storage.write(key: 'refreshToken', value: _token.value!.refreshToken);
    }
    // redecode token
    notifyListeners();
  }

  Future<Token?> signIn(String email, String password) async {
    Token? token = await _authService.login(email, password);

    if (token != null) {
      _token.value = token;
    }
    return token;
  }

  void logout() {
    _token.value = null;
  }

  Future<Token?> getToken() async {
    if (_token.value == null) return null;
    var accessToken = _token.value!.accessToken;
    Duration remainingTime = JwtDecoder.getRemainingTime(accessToken);
    if (remainingTime < Duration(minutes: 1)) {
      //refresh
      print('Token expired. Trying to refresh.');
      Token? updatedToken =
          await _authService.refreshAccessToken(_token.value!);
      _token.value = updatedToken;
    } else {
      return _token.value;
    }
  }

  Future<Token?> register(String email, String password) async {
    Token? token = await _authService.register(email, password);
    if (token != null) {
      _token.value = token;
    }
    return token;
  }
}
