import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:hikees/components/gallery/gallery.dart';
import 'package:hikees/components/gallery/gallery_binding.dart';
import 'package:hikees/messages.dart';
import 'package:hikees/middlewares/auth.dart';
import 'package:hikees/pages/account/bookmarks/account_bookmarks_binding.dart';
import 'package:hikees/pages/account/bookmarks/account_bookmarks_page.dart';
import 'package:hikees/pages/account/offline_trails/offline_trails_binding.dart';
import 'package:hikees/pages/account/offline_trails/offline_trails_page.dart';
import 'package:hikees/pages/account/password/account_password_binding.dart';
import 'package:hikees/pages/account/password/account_password_page.dart';
import 'package:hikees/pages/account/preferences/account_preferences_binding.dart';
import 'package:hikees/pages/account/preferences/account_preferences_page.dart';
import 'package:hikees/pages/account/privacy/account_privacy_binding.dart';
import 'package:hikees/pages/account/privacy/account_privacy_page.dart';
import 'package:hikees/pages/account/profile/account_profile_binding.dart';
import 'package:hikees/pages/account/profile/account_profile_page.dart';
import 'package:hikees/pages/account/records/account_records_binding.dart';
import 'package:hikees/pages/account/records/account_records_page.dart';
import 'package:hikees/pages/account/saved_records/saved_records_binding.dart';
import 'package:hikees/pages/account/saved_records/saved_records_page.dart';
import 'package:hikees/pages/account/topics/account_topics_binding.dart';
import 'package:hikees/pages/account/topics/account_topics_page.dart';
import 'package:hikees/pages/account/trails/account_trails_binding.dart';
import 'package:hikees/pages/account/trails/account_trails_page.dart';
import 'package:hikees/pages/auth/login_binding.dart';
import 'package:hikees/pages/auth/login_page.dart';
import 'package:hikees/pages/auth/register.dart';
import 'package:hikees/pages/auth/register_binding.dart';
import 'package:hikees/pages/events/create_event/create_event_binding.dart';
import 'package:hikees/pages/events/create_event/create_event_page.dart';
import 'package:hikees/pages/home/home_binding.dart';
import 'package:hikees/pages/home/home_page.dart';
import 'package:hikees/pages/profile/profile_binding.dart';
import 'package:hikees/pages/profile/profile_page.dart';
import 'package:hikees/pages/record/record_binding.dart';
import 'package:hikees/pages/record/record_page.dart';
import 'package:hikees/pages/topic/topic_binding.dart';
import 'package:hikees/pages/topic/topic_page.dart';
import 'package:hikees/pages/topics/create/create_topic_binding.dart';
import 'package:hikees/pages/topics/create/create_topic_page.dart';
import 'package:hikees/pages/trail/trail_binding.dart';
import 'package:hikees/pages/trail/trail_events/trail_events_binding.dart';
import 'package:hikees/pages/trail/trail_events/trail_events_page.dart';
import 'package:hikees/pages/trail/trail_page.dart';
import 'package:hikees/pages/trails/category/trail_category_binding.dart';
import 'package:hikees/pages/trails/category/trail_category_page.dart';
import 'package:hikees/pages/trails/create/create_trail_binding.dart';
import 'package:hikees/pages/trails/create/create_trail_page.dart';
import 'package:hikees/providers/preferences.dart';
import 'package:hikees/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // FlavorConfig(
  //   name: "DEVELOP",
  //   variables: {
  //     "API_ENDPOINT": "http://127.0.0.1:3000/",
  //   },
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final preferencesProvider = Get.put(PreferencesProvider());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hikee',
      theme: Themes.light,
      translations: Messages(),
      defaultTransition: Transition.cupertino,
      initialRoute: '/',
      fallbackLocale: Locale('en', 'US'),
      builder: (_, widget) {
        if (widget == null) return Container();
        return widget;
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
            middlewares: [AuthMiddleware()]),
        // GetPage(
        //   name: '/trails/categories',
        //   page: () => TrailCategoriesPage(),
        //   binding: TrailCategoriesBinding(),
        // ),
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
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/records/:id',
          page: () => RecordPage(),
          binding: RecordBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/records',
          page: () => AccountRecordsPage(),
          binding: AccountRecordsBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/topics/create',
          page: () => CreateTopicPage(),
          binding: CreateTopicBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/topics/:id',
          page: () => TopicPage(),
          binding: TopicBinding(),
        ),
        GetPage(
          name: '/topics/:topicId/reply',
          page: () => CreateTopicPage(),
          binding: CreateTopicBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/profiles/:userId',
          page: () => ProfilePage(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: '/preferences',
          page: () => AccountPreferencesPage(),
          binding: AccountPreferencesBinding(),
        ),
        GetPage(
          name: '/privacy',
          page: () => AccountPrivacyPage(),
          binding: AccountPrivacyBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/profile',
          page: () => AccountProfilePage(),
          binding: AccountProfileBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/bookmarks',
          page: () => AccountBookmarksPage(),
          binding: AccountBookmarksBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/my-trails',
          page: () => AccountTrailsPage(),
          binding: AccountTrailsBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/my-topics',
          page: () => AccountTopicsPage(),
          binding: AccountTopicsBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/offline-trails',
          page: () => OfflineTrailsPage(),
          binding: OfflineTrailsBinding(),
          middlewares: [],
        ),
        GetPage(
          name: '/saved-records',
          page: () => SavedRecordsPage(),
          binding: SavedRecordsBinding(),
          middlewares: [],
        ),
        GetPage(
          name: '/saved-records/:id',
          page: () => RecordPage(),
          binding: RecordBinding(),
          middlewares: [],
        ),
        GetPage(
          name: '/gallery',
          page: () => Gallery(),
          binding: GalleryBinding(),
          middlewares: [],
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
