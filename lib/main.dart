import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:hikee/pages/topic/topic_binding.dart';
import 'package:hikee/pages/topic/topic_page.dart';
import 'package:hikee/pages/topics/create/create_topic_binding.dart';
import 'package:hikee/pages/topics/create/create_topic_page.dart';
import 'package:hikee/pages/trail/trail_binding.dart';
import 'package:hikee/pages/trail/trail_page.dart';
import 'package:hikee/pages/trails/categories/trail_categories_binding.dart';
import 'package:hikee/pages/trails/categories/trail_categories_page.dart';
import 'package:hikee/pages/trails/category/trail_category_binding.dart';
import 'package:hikee/pages/trails/category/trail_category_page.dart';
import 'package:hikee/pages/trails/create/create_trail_binding.dart';
import 'package:hikee/pages/trails/create/create_trail_page.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/map_marker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //MapMarker();
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
          name: '/trails/create',
          page: () => CreateTrailPage(),
          binding: CreateTrailBinding(),
        ),
        GetPage(
          name: '/trails/categories',
          page: () => TrailCategoriesPage(),
          binding: TrailCategoriesBinding(),
        ),
        GetPage(
          name: '/trails/categories/:id',
          page: () => TrailCategoryPage(),
          binding: TrailCategoryBinding(),
        ),
        GetPage(
          name: '/trails/:id',
          page: () => TrailPage(),
          binding: TrailBinding(),
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
          name: '/topics/create',
          page: () => CreateTopicPage(),
          binding: CreateTopicBinding(),
        ),
        GetPage(
          name: '/topics/:id',
          page: () => TopicPage(),
          binding: TopicBinding(),
        ),
        GetPage(
            name: '/login', page: () => LoginPage(), binding: LoginBinding()),
        GetPage(
            name: '/register',
            page: () => RegisterPage(),
            binding: RegisterBinding()),
      ],
    );
  }
}
