import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/manager/token.dart';
import 'package:hikees/models/error/error_response.dart';
import 'package:hikees/models/token.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class BaseProvider extends GetConnect {
  static TokenManager _tokenManager = TokenManager();
  Future<void>? _refreshTokenFuture;
  List<CancelableOperation> _operations = [];

  String getUrl() {
    var endpoint = FlavorConfig.instance.variables["API_ENDPOINT"] ??
        "https://api.hikees.com/";
    return endpoint;
  }

  @override
  void onInit() {
    super.onInit();
    httpClient.errorSafety = false;
    httpClient.baseUrl = getUrl();
    httpClient.addRequestModifier<void>((request) async {
      request.headers['connection'] = 'keep-alive';
      if (kIsWeb) {
        request.headers.remove('user-agent');
        request.headers.remove('content-length');
        request.headers['Access-Control-Allow-Origin'] = '*';
      }
      if (request.url.path.contains('/auth')) return request;
      if (_tokenManager.token != null) {
        if (_tokenManager.nearlyExpire) {
          if (_refreshTokenFuture == null) {
            print('Token expired. Trying to refresh.');
            _refreshTokenFuture = _refreshToken();
          }
          await _refreshTokenFuture;
        }
        request.headers["Authorization"] =
            "Bearer ${_tokenManager.token!.accessToken}";
      }
      return request;
    });
    httpClient.addResponseModifier((request, response) {
      if (![200, 201].contains(response.statusCode)) {
        print(response.body);
        throw ErrorResponse.fromJson(response.body as Map<String, dynamic>);
      }
      print(response.body);
      return response;
    });
  }

  Future<void> _refreshToken() async {
    Duration remainingTime =
        JwtDecoder.getRemainingTime(_tokenManager.token!.refreshToken);
    if (remainingTime < Duration(minutes: 1)) {
      //refresh
      print('Refresh token expired. Logout now');
      _tokenManager.token = null;
      throw new Exception('Refresh token expired');
      //return;
    }
    print('trying refresh');
    var res = await post(
        'auth/refresh', {'refreshToken': _tokenManager.token!.refreshToken});
    Token updatedToken = Token.fromJson((_tokenManager.token!
          ..updateAccessToken(res.body['accessToken']))
        .toJson());
    _tokenManager.token = updatedToken;
    _refreshTokenFuture = null;
  }

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    return await _retry(super.get(url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder));
  }

  Future<Response<T>> postWithRetry<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    return await _retry(super.post<T>(
      url,
      body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    ));
  }

  Future<dynamic> _retry(Future<dynamic> future, [int times = 0]) async {
    if (times > 3) {
      throw new Error();
    }
    CancelableOperation<dynamic>? cancellableOperation;
    try {
      cancellableOperation = CancelableOperation.fromFuture(future);
      _operations.add(cancellableOperation);
      final result = await cancellableOperation.value;
      _operations.remove(cancellableOperation);
      return result;
    } catch (ex) {
      if (cancellableOperation != null)
        _operations.remove(cancellableOperation);
      return await Future.delayed(
          const Duration(seconds: 5), () => _retry(future, times + 1));
    }
  }

  @override
  void onClose() {
    _operations.forEach((o) {
      o.cancel();
    });
    super.onClose();
  }
}
