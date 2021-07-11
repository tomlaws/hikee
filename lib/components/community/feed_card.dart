import 'package:flutter/material.dart';

// https://www.laughtraveleat.com/wp-content/uploads/2018/12/at-the-neck-of-lion-rock-kowloon-hong-kong-laugh-travel-eat.jpg

class CommunityFeedCard extends StatelessWidget {
  const CommunityFeedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Container(
            margin: const EdgeInsets.only(left: 18),
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // club name + location
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "XX hiking club",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "@ Lion Hill",
                      style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
                // vote
                Row(
                  children: [
                    Text("6"),
                    IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up_alt_outlined))
                  ],
                )
              ],
            ),
          ),

          // img
          Image.network(
              'https://www.laughtraveleat.com/wp-content/uploads/2018/12/at-the-neck-of-lion-rock-kowloon-hong-kong-laugh-travel-eat.jpg'),

          // Description
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18,),
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Text(
                  "XX hiking club",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                ),
                Text("What a beautiful day!"),
              ],
            ),
          ),

          // Comment
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              "Add a comment...",
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }
}
