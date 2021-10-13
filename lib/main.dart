import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hikee/messages.dart';
import 'package:hikee/pages/account/records/account_records_binding.dart';
import 'package:hikee/pages/account/records/account_records_page.dart';
import 'package:hikee/pages/auth/login_binding.dart';
import 'package:hikee/pages/auth/login_page.dart';
import 'package:hikee/pages/auth/register.dart';
import 'package:hikee/pages/auth/register_binding.dart';
import 'package:hikee/pages/home/home_binding.dart';
import 'package:hikee/pages/home/home_page.dart';
import 'package:hikee/pages/record/record_binding.dart';
import 'package:hikee/pages/record/record_page.dart';
import 'package:hikee/pages/route/route_binding.dart';
import 'package:hikee/pages/route/route_page.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/map_marker.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
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
      defaultTransition: Transition.cupertino,
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
          name: '/records/:id',
          page: () => RecordPage(),
          binding: RecordBinding(),
        ),
        GetPage(
          name: '/records',
          page: () => AccountRecordsPage(),
          binding: AccountRecordsBinding(),
        ),
        GetPage(
            name: '/login', page: () => LoginPage(), binding: LoginBinding()),
        GetPage(
            name: '/register',
            page: () => RegisterPage(),
            binding: RegisterBinding()),
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
