import 'package:flutter/material.dart';
import 'package:hikee/components/community/search_bar.dart';
import 'package:hikee/components/community/group/group_card.dart';

class CommunityGroupTab extends StatefulWidget {
  const CommunityGroupTab({ Key? key }) : super(key: key);

  @override
  _CommunityGroupTabState createState() => _CommunityGroupTabState();
}

class _CommunityGroupTabState extends State<CommunityGroupTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: ListView(
        children: [
          SearchBar(),
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
  
}