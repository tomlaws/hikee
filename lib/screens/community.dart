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
              padding: EdgeInsets.fromLTRB(
                  _horizontalPadding, 12, _horizontalPadding, 0),
              height: _headerHeight,
              child: Text("Community", style: TextStyle(fontSize: 32)),
            ),

            // Buttonsgroup
            Container(
              margin: EdgeInsets.fromLTRB(
                  _horizontalPadding, 0, _horizontalPadding, 4),
              padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  border: Border.all(
                    width: 1.0,
                    color: Theme.of(context).primaryColor,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // New + Hot
                  ToggleButtons(
                    renderBorder: false,
                    color: Colors.grey[400],
                    selectedColor: Theme.of(context).primaryColor,
                    isSelected: isSelected,
                    fillColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: (int index) {
                      setState(() {
                        if (isSelected[index]) return;

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
                            Text("New",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .5))
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
                            Text("Hot",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .5))
                          ],
                        ),
                      )
                    ],
                  ),

                  // search + create
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                        ),
                        tooltip: 'Search Post',
                        splashColor: Colors.grey[200],
                        splashRadius: 24,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                        tooltip: 'Create Post',
                        splashColor: Colors.grey[200],
                        splashRadius: 24,
                      ),
                    ],
                  )
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
                          height: 0.5,
                        ),
                    itemCount: 10))
          ],
        ),
      ),
    );
  }
}
