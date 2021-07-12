import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/community/title.dart';
import 'package:hikee/components/community/group_card.dart';
import 'package:hikee/components/community/feed_card.dart';
import 'package:hikee/components/text_input.dart';

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
      _feedTab(),
      _groupTab(),
      _friendTab(context)
    ];
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

  Widget _searchBar(String hint) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: TextInput(
        hintText: hint,
      ),
    );
  }

  Widget _feedTab() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ListView(
        children: [
          CommunityFeedCard(),
          CommunityFeedCard(),
          CommunityFeedCard(),
          CommunityFeedCard(),
        ],
      ),
    );
  }

  Widget _groupTab() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: ListView(
        children: [
          _searchBar("search a group..."),
          Container(
            padding: const EdgeInsets.only(bottom: 6),
          ),
          CommunityGroupCard(),
          CommunityGroupCard(),
          CommunityGroupCard(),
          CommunityGroupCard(),
          CommunityGroupCard(),
        ],
      ),
    );
  }

  // Friends
  Widget _buildHeader(String text) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRow() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            'https://lh3.googleusercontent.com/proxy/8TmFNSq3UQd2RUqHByJnO9L8LlLCIB0rZivHDR2w1NgIHHmoH6pXC1pDWf2NlS7t-LUSs1F5wxvVpp3RQmD3ixDrK343pVmlsAZwp-8u6ajPudB8b464rOZ9Kw'),
      ),
      title: Text("Alan"),
    );
  }

  Widget _friendTab(BuildContext context) {
    List<Widget> recentFriends =
        new List<Widget>.generate(3, (index) => _buildRow());
    final int recentFriendsLength = 3;
    List<Widget> allFriends =
        new List<Widget>.generate(100, (index) => _buildRow());
    final int allFriendsLength = 100;

    var wholeList = [
      _searchBar("search a friend..."),
      _buildHeader("Recent"),
      ...recentFriends,
      _buildHeader("All"),
      ...allFriends
    ];

    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: ListView.builder(
        itemCount: wholeList.length,
        itemBuilder: (context, i) {
          return wholeList[i];
        },
      ),
    );
  }
}
