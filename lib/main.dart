import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/panel_position.dart';
import 'package:hikee/screens/community.dart';
import 'package:hikee/screens/events.dart';
import 'package:hikee/screens/home.dart';
import 'package:hikee/screens/library.dart';
import 'package:hikee/screens/profile.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PanelPosition()),
        ChangeNotifierProvider(create: (_) => ActiveHikingRoute()),
      ],
      child: MyApp(),
    ),
  );
}

const Color themeColor = Color(0xFF5DB075);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hikee',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: themeColor,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: themeColor,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: MyHomePage(title: 'Hikee')));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    LibraryScreen(),
    EventsScreen(),
    CommunityScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: IndexedStack(children: _widgetOptions, index: _selectedIndex),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
