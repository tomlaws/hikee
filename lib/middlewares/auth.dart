import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikees/providers/auth.dart';

class AuthMiddleware extends GetMiddleware {
  final authProvider = Get.put(AuthProvider());

  @override
  RouteSettings? redirect(String? route) {
    return authProvider.loggedIn.value || route == '/login'
        ? null
        : RouteSettings(name: '/login');
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    return bindings;
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }

  @override
  void onPageDispose() {}
}
