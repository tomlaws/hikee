import 'package:flutter/material.dart';

class CommunityPostTile extends StatefulWidget {
  const CommunityPostTile({Key? key}) : super(key: key);

  @override
  _CommunityPostTileState createState() => _CommunityPostTileState();
}

class _CommunityPostTileState extends State<CommunityPostTile> {
  @override
  Widget build(BuildContext context) {
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
                child: Row(
                  children:[
                    CircleAvatar(
                      backgroundImage: NetworkImage("https://lh3.googleusercontent.com/proxy/3vQYnbwA06rXh2WVxixTJD2QDPoRFsUeADSkI2UaG8URNNpHN82c8sGPr30vy2-N-KLezOGuxlNRmbQCjopSkzHK39Cg_pgvZlmO9HH97E2Hz8Bh5H0YlZhkfw"),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Text("Chan Siu Ming"), 
                  ]
                )
              ),
              
              Text("4 hours ago")
            ],
          ),
          // title
          Container(
            child: Text(
              "Can you guys suggest some beginner friendly routes?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // like + comments
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Like
                  Expanded(
                    child:  TextButton.icon(
                      onPressed: () {},
                      label: Text("12", style: TextStyle(color: Colors.grey[500]),),
                      icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.grey[500],)),
                  ),
                  
                  // Comments
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {}, 
                      label: Text("8", style: TextStyle(color: Colors.grey[500])), 
                      icon: Icon(Icons.comment_outlined, color: Colors.grey[500]),
                    )
                  )
                ],
              )),
        ],
      ),
    );
  }
}
