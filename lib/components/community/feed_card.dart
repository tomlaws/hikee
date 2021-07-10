import 'package:flutter/material.dart';

// https://www.laughtraveleat.com/wp-content/uploads/2018/12/at-the-neck-of-lion-rock-kowloon-hong-kong-laugh-travel-eat.jpg

class CommunityFeedCard extends StatelessWidget {
  const CommunityFeedCard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      child: Column(
        children: [

          // title
          Container(
            child: Column(
              children: [
                Text("Clement", style: TextStyle(fontSize: 12, color: Colors.black),),
                Text("Lion Hill", style: TextStyle(fontSize: 8, color: Colors.grey[400]),)
              ],
            ),
          ),

          // img
          Image.network(
              'https://www.laughtraveleat.com/wp-content/uploads/2018/12/at-the-neck-of-lion-rock-kowloon-hong-kong-laugh-travel-eat.jpg'),

          // Description
          Container(
            child: Text("What a beautiful day!"),
          )

        ],
      ),
    );
  }
}