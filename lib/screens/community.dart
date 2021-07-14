import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/button.dart';

import 'package:hikee/components/community_post_tile.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final double _headerHeight = 60;
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              height: _headerHeight,
              child: Text("Community", style: TextStyle(fontSize: 32)),
            ),

            // Buttonsgroup
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              padding: EdgeInsets.symmetric(horizontal: 18),
              decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // New + Hot
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(25),
                    renderBorder: false,
                    selectedColor: Colors.grey,
                    selectedBorderColor: Colors.black,
                    isSelected: isSelected,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.align_vertical_bottom_rounded,
                              color: Colors.white,
                            ),
                            Text(
                              "New",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Icon(Icons.local_fire_department,
                                color: Colors.white),
                            Text("Hot", style: TextStyle(color: Colors.white))
                          ],
                        ),
                      )
                    ],
                  ),

                  // Create Post
                  Button(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text("Create Post")
                        ],
                      ))
                ],
              ),
            ),

            // List
            Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return CommunityPostTile();
                    },
                    separatorBuilder: (context, index) => const Divider(
                          height: 1.0,
                        ),
                    itemCount: 10))
          ],
        )),
      ),
    );
  }
}
