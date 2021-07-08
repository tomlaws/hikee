import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/community/title.dart';
import 'package:hikee/components/community/card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {},
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        // whole
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          // whole
          child: Column(children: [
            Expanded(
                child: ListView(
              children: [
                // title
                CommunityTitle(),
                // Cards
                CommunityCard(),
                CommunityCard(),
              ],
            ))
          ]),
        ),
      ),
    );
  }
}
