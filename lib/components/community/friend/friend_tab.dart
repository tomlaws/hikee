import 'package:flutter/material.dart';
import 'package:hikee/components/community/search_bar.dart';

class CommunityFriendTab extends StatefulWidget {
  const CommunityFriendTab({ Key? key }) : super(key: key);

  @override
  _CommunityFriendTabState createState() => _CommunityFriendTabState();
}

class _CommunityFriendTabState extends State<CommunityFriendTab> {
  @override
  Widget build(BuildContext context) {
    List<Widget> recentFriends =
      new List<Widget>.generate(3, (index) => _buildRow());
    List<Widget> allFriends =
      new List<Widget>.generate(20, (index) => _buildRow());

    var wholeList = [
      SearchBar(),
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
            'https://southernescaperoom.com/wp-content/uploads/2019/04/team.png'),
      ),
      title: Text("Alan"),
    );
  }
}