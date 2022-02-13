import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/messages.dart';
import 'package:hikee/pages/account/password/account_password_binding.dart';
import 'package:hikee/pages/account/password/account_password_page.dart';
import 'package:hikee/pages/account/privacy/account_privacy_binding.dart';
import 'package:hikee/pages/account/privacy/account_privacy_page.dart';
import 'package:hikee/pages/account/records/account_records_binding.dart';
import 'package:hikee/pages/account/records/account_records_page.dart';
import 'package:hikee/pages/auth/login_binding.dart';
import 'package:hikee/pages/auth/login_page.dart';
import 'package:hikee/pages/auth/register.dart';
import 'package:hikee/pages/auth/register_binding.dart';
import 'package:hikee/pages/events/create_event/create_event_binding.dart';
import 'package:hikee/pages/events/create_event/create_event_page.dart';
import 'package:hikee/pages/home/home_binding.dart';
import 'package:hikee/pages/home/home_page.dart';
import 'package:hikee/pages/profile/profile_binding.dart';
import 'package:hikee/pages/profile/profile_page.dart';
import 'package:hikee/pages/record/record_binding.dart';
import 'package:hikee/pages/record/record_page.dart';
import 'package:hikee/pages/topic/topic_binding.dart';
import 'package:hikee/pages/topic/topic_page.dart';
import 'package:hikee/pages/topics/create/create_topic_binding.dart';
import 'package:hikee/pages/topics/create/create_topic_page.dart';
import 'package:hikee/pages/trail/trail_binding.dart';
import 'package:hikee/pages/trail/trail_events/trail_events_binding.dart';
import 'package:hikee/pages/trail/trail_events/trail_events_page.dart';
import 'package:hikee/pages/trail/trail_page.dart';
import 'package:hikee/pages/trails/categories/trail_categories_binding.dart';
import 'package:hikee/pages/trails/categories/trail_categories_page.dart';
import 'package:hikee/pages/trails/category/trail_category_binding.dart';
import 'package:hikee/pages/trails/category/trail_category_page.dart';
import 'package:hikee/pages/trails/create/create_trail_binding.dart';
import 'package:hikee/pages/trails/create/create_trail_page.dart';
import 'package:hikee/themes.dart';

void main() {
  runApp(MyApp());
}

// Remove glow effect for scroll views from flutter framework
class CustomOverscrollIndicator extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    // var opacity = [1.0, 1.0];
    // var wrapped = StatefulBuilder(builder: (_, setState) {
    //   return NotificationListener<ScrollNotification>(
    //     onNotification: (scrollNotification) {
    //       var v = scrollNotification.metrics.viewportDimension;
    //       // apply fading edge only to small view
    //       if (v > MediaQuery.of(context).size.height / 2) {
    //         return true;
    //       }
    //       var b = scrollNotification.metrics.extentBefore;
    //       var a = scrollNotification.metrics.extentAfter;
    //       setState(() {
    //         opacity = [
    //           1 - (b * 20).clamp(0, 100) / 100,
    //           1 - (a * 20).clamp(0, 100) / 100
    //         ];
    //       });
    //       return false;
    //     },
    //     child: ShaderMask(
    //       shaderCallback: (Rect bounds) {
    //         return LinearGradient(
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter,
    //           stops: [0.0, 0.2, 0.8, 1.0],
    //           colors: <Color>[
    //             Colors.white
    //                 .withOpacity(opacity[0]), //opacity: 0=fade, 1 = sharpedge
    //             Colors.white,
    //             Colors.white,
    //             Colors.white.withOpacity(opacity[1])
    //           ],
    //         ).createShader(bounds);
    //       },
    //       child: child,
    //       blendMode: BlendMode.dstIn,
    //     ),
    //   );
    // });
    return super.buildScrollbar(context, child, details);
  }
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
      builder: (_, widget) {
        if (widget == null) return Container();
        return ScrollConfiguration(
            behavior: CustomOverscrollIndicator(), child: widget);
      },
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
          name: '/trails/events/:id',
          page: () => TrailEventsPage(),
          binding: TrailEventsBinding(),
        ),
        GetPage(
          name: '/trails/:id',
          page: () => TrailPage(),
          binding: TrailBinding(),
        ),
        GetPage(
          name: '/events/create/:trailId',
          page: () => CreateEventPage(),
          binding: CreateEventBinding(),
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
          name: '/profiles/:id',
          page: () => ProfilePage(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: '/privacy',
          page: () => AccountPrivacyPage(),
          binding: AccountPrivacyBinding(),
        ),
        GetPage(
          name: '/password',
          page: () => AccountPasswordPage(),
          binding: AccountPasswordBinding(),
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
