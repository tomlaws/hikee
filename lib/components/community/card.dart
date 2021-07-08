import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.black,
      child: Column(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                'https://ychef.files.bbci.co.uk/live/624x351/p0973lkk.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "XX Hiking Club",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris",
                          style: TextStyle(color: Colors.grey))
                    ],
                  )),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("123 members"),
                        Button(
                          onPressed: () {},
                          child: Text("JOIN"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
