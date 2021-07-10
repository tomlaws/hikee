import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/community/title.dart';
import 'package:hikee/components/community/card.dart';
import 'package:hikee/components/community/feed_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Feed'),
    Tab(text: 'Groups'),
    Tab(text: 'Friends'),
  ];

  late List<Widget> tabViews;

  @override
  void initState() {
    tabViews = [
      _feedTab(),
      _groupTab(),
      Text("Friends"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios_new),
      //     onPressed: () {},
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),

      body: SafeArea(
          // whole
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
            child: CommunityTitle(),
          ),

          // Tabs + Views
          Flexible(
            child: DefaultTabController(
                length: myTabs.length,
                child: Column(
                  children: [
                    // tabs
                    _tabBar(),
                    // views
                    Flexible(
                      child: TabBarView(children: tabViews),
                    )
                  ],
                )),
          ),
        ],
      )),
    );
  }

  Widget _tabBar() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(25)),
        child: TabBar(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).primaryColor,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: myTabs,
        ));
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(), hintText: "Search a group..."),
    );
  }

  Widget _feedTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      children: [
        CommunityFeedCard(),
        CommunityFeedCard(),
        CommunityFeedCard(),
        CommunityFeedCard(),
      ],
    );
  }

  Widget _groupTab() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: ListView(
        children: [
          _searchBar(),
          Container(
            padding: const EdgeInsets.only(bottom: 22),
          ),
          CommunityCard(),
          CommunityCard(),
          CommunityCard(),
          CommunityCard(),
          CommunityCard(),
        ],
      ),
    );
  }
}
