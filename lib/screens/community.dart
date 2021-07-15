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
  final double _horizontalPadding = 18;
  final double _borderRadius = 25;
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // Header
        Container(
          padding: EdgeInsets.fromLTRB(_horizontalPadding, 12, _horizontalPadding, 0),
          height: _headerHeight,
          child: Text("Community", style: TextStyle(fontSize: 32)),
        ),

        // Buttonsgroup
        Container(
          margin: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 12),
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          decoration: new BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(_borderRadius)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // New + Hot
              ToggleButtons(
                renderBorder: false,
                color: Colors.white,
                selectedColor: Colors.blue,
                isSelected: isSelected,
                fillColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < 2; ++i) {
                      i == index
                          ? isSelected[i] = !isSelected[i]
                          : isSelected[i] = false;
                    }
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.align_vertical_bottom_rounded,
                        ),
                        Text(
                          "New",
                          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: .5)
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                        ),
                        Text(
                          "Hot",
                          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: .5)
                        )
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
        ),
      ),
    );
  }
}
