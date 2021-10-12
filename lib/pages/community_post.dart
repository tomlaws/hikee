import 'package:flutter/material.dart';

class CommunityPostScreen extends StatefulWidget {
  final int id;
  const CommunityPostScreen({Key? key, required this.id}) : super(key: key);

  @override
  _CommunityPostScreenState createState() => _CommunityPostScreenState();
}

class _CommunityPostScreenState extends State<CommunityPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: Text("Can someone suggest a route for me as a beginner?",
                style: TextStyle(
                  color: Colors.white,
                )),
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _postHeader(),
                ],
              ),
            )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return comment();
            },
            childCount: 20,
          ),
        ),
      ],
    ));
  }

  Widget _postHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.thestatesman.com/wp-content/uploads/2017/08/1493458748-beauty-face-517.jpg"),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                Text("Chan Siu Ming",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
              ])),
              Text("4 hours ago", style: TextStyle(color: Colors.white))
            ],
          ),
          // content
          Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: TextStyle(color: Colors.white))),
          Row(
            children: [
              TextButton.icon(
                  onPressed: () {},
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(0)),
                    alignment: Alignment.centerLeft,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  label: Text(
                    "12",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.white)),
              TextButton.icon(
                onPressed: () {},
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                  alignment: Alignment.centerLeft,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                label: Text("8", style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.comment_outlined, color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget comment() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // poster
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.faceapp.com/img/content/compare/beard-example-before@3x.jpg"),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                Text(
                  "Wong Chi Wai",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ])),
              Text("32 miniutes ago")
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 52),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // comment
                Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Phoenix Hill is a good choice",
                    style: TextStyle(),
                  ),
                ),

                // like
                TextButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(0)),
                      alignment: Alignment.centerLeft,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    label: Text(
                      "12",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    icon: Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Colors.grey[400],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}