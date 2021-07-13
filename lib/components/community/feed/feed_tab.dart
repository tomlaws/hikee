import 'package:flutter/material.dart';
import 'package:hikee/components/community/feed/feed_card.dart';

class CommunityFeedTab extends StatefulWidget {
  const CommunityFeedTab({Key? key}) : super(key: key);

  @override
  _CommunityFeedTabState createState() => _CommunityFeedTabState();
}

class _CommunityFeedTabState extends State<CommunityFeedTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 12),
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, i) {
              return CommunityFeedCard();
            }));
  }
}
