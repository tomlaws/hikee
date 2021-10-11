import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/login_prompt.dart';
import 'package:hikee/messages.dart';
import 'package:hikee/old_providers/auth.dart';
import 'package:hikee/pages/auth/login_binding.dart';
import 'package:hikee/pages/auth/login_page.dart';
import 'package:hikee/pages/home/home_binding.dart';
import 'package:hikee/pages/home/home_page.dart';
import 'package:hikee/pages/route/route_binding.dart';
import 'package:hikee/pages/route/route_page.dart';
import 'package:hikee/pages/search/search_binding.dart';
import 'package:hikee/pages/search/search_page.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/map_marker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MapMarker();
    var locale = Locale('zh');
    Get.testMode = true;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hikee',
      theme: Themes.light,
      translations: Messages(),
      locale: Locale('en', 'US'),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/routes/:id',
          page: () => RoutePage(),
          binding: RouteBinding(),
        ),
        GetPage(
            name: '/login', page: () => LoginPage(), binding: LoginBinding()),
      ],
      //home: HomePage(),
      //initialBinding: HomeBinding()
    );
  }

  // Widget _protected(BuildContext context, Widget child) {
  //   return Selector<AuthProvider, bool>(
  //     selector: (_, p) => p.loggedIn,
  //     builder: (_, loggedIn, __) {
  //       if (loggedIn) return child;
  //       return LoginPrompt();
  //     },
  //   );
  // }
}
