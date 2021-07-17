import 'package:flutter/material.dart';

class CommunityPostTile extends StatefulWidget {
  final void Function()? onTap;
  const CommunityPostTile({Key? key, this.onTap}) : super(key: key);

  @override
  _CommunityPostTileState createState() => _CommunityPostTileState();
}

class _CommunityPostTileState extends State<CommunityPostTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
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
                        backgroundImage: NetworkImage("https://www.thestatesman.com/wp-content/uploads/2017/08/1493458748-beauty-face-517.jpg"),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
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
              padding: const EdgeInsets.only(top: 4),
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
                      label: Text("12", style: TextStyle(color: Colors.grey[400]),),
                      icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.grey[400],)),
                  ),
                  
                  // Comments
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {}, 
                      label: Text("8", style: TextStyle(color: Colors.grey[400])), 
                      icon: Icon(Icons.comment_outlined, color: Colors.grey[400]),
                    )
                  )
                ],
              )
            ),
          ],
        ),
      )
    );
  }
}
