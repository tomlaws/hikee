import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikee/components/login_prompt.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/models/current_location.dart';
import 'package:hikee/models/hiking_stat.dart';
import 'package:hikee/providers/event.dart';
import 'package:hikee/providers/event_participations.dart';
import 'package:hikee/providers/events.dart';
import 'package:hikee/providers/locale.dart';
import 'package:hikee/providers/me.dart';
import 'package:hikee/providers/bookmarks.dart';
import 'package:hikee/providers/route.dart';
import 'package:hikee/providers/route_reviews.dart';
import 'package:hikee/providers/routes.dart';
import 'package:hikee/providers/topic.dart';
import 'package:hikee/providers/topic_replies.dart';
import 'package:hikee/providers/topics.dart';
import 'package:hikee/pages/account.dart';
import 'package:hikee/pages/account/bookmarks.dart';
import 'package:hikee/pages/auth/login.dart';
import 'package:hikee/pages/auth/register.dart';
import 'package:hikee/pages/event.dart';
import 'package:hikee/pages/events.dart';
import 'package:hikee/pages/home.dart';
import 'package:hikee/pages/topic.dart';
import 'package:hikee/pages/topics.dart';
import 'package:hikee/pages/route.dart';
import 'package:hikee/pages/routes.dart';
import 'package:hikee/services/auth.dart';
import 'package:hikee/services/bookmark.dart';
import 'package:hikee/services/event.dart';
import 'package:hikee/services/route.dart';
import 'package:hikee/services/topic.dart';
import 'package:hikee/services/user.dart';
import 'package:hikee/services/weather.dart';
import 'package:hikee/utils/map_marker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:routemaster/routemaster.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => AuthService());
  GetIt.I.registerLazySingleton(() => UserService());
  GetIt.I.registerLazySingleton(() => RouteService());
  GetIt.I.registerLazySingleton(() => BookmarkService());
  GetIt.I.registerLazySingleton(() => EventService());
  GetIt.I.registerLazySingleton(() => TopicService());
  GetIt.I.registerLazySingleton(() => WeatherService());
}

void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<AuthProvider, MeProvider>(
          create: (context) =>
              MeProvider(authProvider: context.read<AuthProvider>()),
          update: (_, authProvider, __) =>
              MeProvider(authProvider: authProvider),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<AuthProvider, RouteProvider>(
          create: (context) =>
              RouteProvider(authProvider: context.read<AuthProvider>()),
          update: (_, authProvider, routeProvider) =>
              RouteProvider(authProvider: authProvider),
          lazy: true,
        ),
        ChangeNotifierProvider(create: (_) => RoutesProvider()),
        ChangeNotifierProxyProvider2<AuthProvider, RouteProvider,
            RouteReviewsProvider>(
          create: (context) => RouteReviewsProvider(
              authProvider: context.read<AuthProvider>(),
              routeProvider: context.read<RouteProvider>()),
          update: (_, authProvider, routeProvider, routeReviewsProvider) =>
              RouteReviewsProvider(
                  authProvider: authProvider, routeProvider: routeProvider),
          lazy: true,
        ),
        ChangeNotifierProxyProvider<AuthProvider, BookmarksProvider>(
          create: (context) =>
              BookmarksProvider(authProvider: context.read<AuthProvider>()),
          update: (_, authProvider, bookmarksProvider) =>
              bookmarksProvider!..update(authProvider: authProvider),
          lazy: true,
        ),
        ChangeNotifierProxyProvider<AuthProvider, EventsProvider>(
          create: (context) =>
              EventsProvider(authProvider: context.read<AuthProvider>()),
          update: (_, authProvider, eventsProvider) =>
              eventsProvider!..update(authProvider: authProvider),
          lazy: true,
        ),
        ChangeNotifierProxyProvider<AuthProvider, EventProvider>(
          create: (context) =>
              EventProvider(authProvider: context.read<AuthProvider>()),
          update: (_, authProvider, eventProvider) =>
              eventProvider!..update(authProvider: authProvider),
          lazy: true,
        ),
        ChangeNotifierProxyProvider2<AuthProvider, EventProvider,
            EventParticipationsProvider>(
          create: (context) => EventParticipationsProvider(
              authProvider: context.read<AuthProvider>(),
              eventProvider: context.read<EventProvider>()),
          update:
              (_, authProvider, eventProvider, eventParticipationsProvider) =>
                  eventParticipationsProvider!
                    ..update(
                        authProvider: authProvider,
                        eventProvider: eventProvider),
          lazy: true,
        ),
        ChangeNotifierProxyProvider<AuthProvider, TopicsProvider>(
          create: (context) =>
              TopicsProvider(authProvider: context.read<AuthProvider>()),
          update: (_, authProvider, topicProvider) =>
              topicProvider!..update(authProvider: authProvider),
          lazy: true,
        ),
        ChangeNotifierProxyProvider<AuthProvider, TopicProvider>(
          create: (context) =>
              TopicProvider(authProvider: context.read<AuthProvider>()),
          update: (_, authProvider, p) =>
              TopicProvider(authProvider: authProvider),
          lazy: true,
        ),
        ChangeNotifierProxyProvider2<AuthProvider, TopicProvider,
            TopicRepliesProvider>(
          create: (context) => TopicRepliesProvider(
              authProvider: context.read<AuthProvider>(),
              topicProvider: context.read<TopicProvider>()),
          update: (_, authProvider, topicProvider, routeReviewsProvider) =>
              TopicRepliesProvider(
                  authProvider: authProvider, topicProvider: topicProvider),
          lazy: true,
        ),
        ChangeNotifierProvider(create: (_) => ActiveHikingRoute()),
        ChangeNotifierProvider(
          create: (_) => CurrentLocation(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider2<ActiveHikingRoute, CurrentLocation,
                HikingStat>(
            create: (BuildContext context) => HikingStat(
                Provider.of<ActiveHikingRoute>(context, listen: false),
                Provider.of<CurrentLocation>(context, listen: false)),
            update: (BuildContext context, ActiveHikingRoute route,
                CurrentLocation loc, HikingStat? prev) {
              if (prev != null) {
                return prev..update(route, loc);
              }
              return HikingStat(route, loc);
            }),
      ],
      child: MyApp(),
    ),
  );
}

const Color themeColor = Color(0xFF5DB075);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MapMarker();
    var locale = context.watch<LocaleProvider>().locale;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hikee',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: ThemeData(
        primaryColor: themeColor,
        primaryTextTheme:
            TextTheme(headline6: TextStyle(color: themeColor, fontSize: 18)),
        //appBarTheme: AppBarTheme(textTheme: Theme.of(context).textTheme.apply(displayColor:Colors.red)),
        sliderTheme: SliderThemeData(
            thumbColor: themeColor,
            activeTrackColor: themeColor,
            inactiveTrackColor: themeColor.withOpacity(.25),
            overlayColor: themeColor.withOpacity(.25),
            valueIndicatorColor: Color(0xFFF5F5F5),
            valueIndicatorTextStyle: TextStyle(color: Colors.black87),
            activeTickMarkColor: Colors.white38),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: themeColor,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            showSelectedLabels: false),
        splashColor: Colors.transparent,
        highlightColor: Color(0x0F000000),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Color(0xFF666666)),
        ),
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: _routes),
      routeInformationParser: RoutemasterParser(),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }

  Widget _protected(BuildContext context, Widget child) {
    return Selector<AuthProvider, bool>(
      selector: (_, p) => p.loggedIn,
      builder: (_, loggedIn, __) {
        if (loggedIn) return child;
        return LoginPrompt();
      },
    );
  }

  RouteMap _routes(BuildContext context) {
    return RouteMap(routes: {
      '/': (route) => TabPage(
            child: MyHomePage(),
            paths: ['/home', '/routes', '/events', '/topics', '/profile'],
          ),
      '/home': (route) => CupertinoPage(child: HomeScreen()),
      '/routes': (route) => CupertinoPage(child: RoutesScreen()),
      '/routes/:id': (route) => CupertinoPage(
          child: RouteScreen(id: int.parse(route.pathParameters['id']!))),
      '/events': (route) => CupertinoPage(child: EventsScreen()),
      '/events/:id': (route) => CupertinoPage(
          child: EventPage(id: int.parse(route.pathParameters['id']!))),
      '/topics': (route) => CupertinoPage(child: TopicsPage()),
      '/topics/:id': (route) => CupertinoPage(
          child: TopicPage(id: int.parse(route.pathParameters['id']!))),
      '/profile': (route) {
        return CupertinoPage(child: ProfileScreen());
      },
      '/profile/bookmarks': (route) {
        return CupertinoPage(child: _protected(context, BookmarksPage()));
      },
      '/login': (route) => CupertinoPage(child: LoginScreen()),
      '/register': (route) => CupertinoPage(child: RegisterScreen()),
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late PageController _pageController;

  void initState() {
    super.initState();
    this._pageController =
        PageController(initialPage: this._selectedIndex, keepPage: true);
    Future.microtask(() {
      final tabPage = TabPage.of(context);
      tabPage.controller.addListener(() {
        _pageController.jumpToPage(tabPage.controller.index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          for (final stack in tabPage.stacks) PageStackNavigator(stack: stack),
        ],
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.book_open), label: 'Library'),
          BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.globe), label: 'Events'),
          BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.comments), label: 'Community'),
          BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.user), label: 'Profile')
        ],
        currentIndex: tabPage.controller.index,
        onTap: (i) {
          tabPage.controller.index = i;
        },
      ),
    );
  }
}
