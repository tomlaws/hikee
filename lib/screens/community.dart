import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/community/feed/feed_card.dart';
import 'package:hikee/components/community/title.dart';
import 'package:hikee/components/community/feed/feed_tab.dart';
import 'package:hikee/components/community/group/group_tab.dart';
import 'package:hikee/components/community/friend/friend_tab.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabViews = [
      CommunityFeedTab(),
      CommunityGroupTab(),
      CommunityFriendTab()
    ];
    return Scaffold(

      body: SafeArea(
          // whole
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
}
