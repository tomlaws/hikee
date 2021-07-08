import 'package:flutter/material.dart';

class CommunityTitle extends StatelessWidget {
  const CommunityTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Community",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            "meet friends, make friends, explore...",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
