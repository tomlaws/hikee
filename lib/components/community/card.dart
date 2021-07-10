import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(24),
              offset: Offset(0, 3),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title = club name + number of memebers
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "XXHiking Club",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text("123 members",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12))
                ],
              ),
            ),

            // img
            Image.network(
                'https://ychef.files.bbci.co.uk/live/624x351/p0973lkk.jpg'),

            // container of description + button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // club description
                  Container(
                    padding: const EdgeInsets.symmetric(),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ipsum non neque viverra porttitor eros, lacus, est. Lobortis in egestas hac sit porttitor odio cras suspendisse in. Dictum suspendisse sit iaculis erat morbi arcu eu enim. Eget purus pharetra, ultricies condimentum."),
                  ),
                    // Button
                  Container(
                    padding: const EdgeInsets.symmetric(),
                    child:SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                        onPressed: () {},
                        child: const Text('JOIN', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  )
                ],
              )
            )
          ],
        ),
    );
  }
}
