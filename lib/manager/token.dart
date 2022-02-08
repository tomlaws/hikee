import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hikee/models/token.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenManager {
  static final TokenManager _singleton = TokenManager._internal();

  factory TokenManager() {
    return _singleton;
  }

  TokenManager._internal() {
    _init();
  }

  final _storage = FlutterSecureStorage();
  Rxn<Token?> _token = Rxn<Token?>();

  _init() async {
    await Future.wait([
      _storage.read(key: 'accessToken'),
      _storage.read(key: 'refreshToken')
    ]).then((tokens) {
      if (!tokens.contains(null)) {
        _token.value = Token(accessToken: tokens[0]!, refreshToken: tokens[1]!);
      }
    }).catchError((err) {
      print(err);
      _token.value = null;
    });
    _token.listen((t) {
      _onTokenChange(t);
    });
  }

  _onTokenChange(Token? token) {
    if (token == null) {
      _storage.delete(key: 'accessToken');
      _storage.delete(key: 'refreshToken');
    } else {
      _storage.write(key: 'accessToken', value: token.accessToken);
      _storage.write(key: 'refreshToken', value: token.refreshToken);
    }
  }

  bool get nearlyExpire {
    if (token == null) {
      return true;
    }
    Duration remainingTime = JwtDecoder.getRemainingTime(token!.accessToken);
    if (remainingTime < Duration(minutes: 1)) {
      return true;
    }
    return false;
  }

  int? get userId {
    if (token == null) {
      return null;
    }
    var decoded = JwtDecoder.decode(token!.accessToken);
    return decoded['id'] as int;
  }

  set token(Token? token) {
    _token.value = token;
  }

  Token? get token => _token.value;

  onTokenChange(void Function(Token?) onData) {
    _token.listen(onData);
  }
}
