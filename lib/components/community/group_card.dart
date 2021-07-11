import 'package:flutter/material.dart';

//             Image.network('https://ychef.files.bbci.co.uk/live/624x351/p0973lkk.jpg'),

class CommunityGroupCard extends StatelessWidget {
  const CommunityGroupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 7, offset: Offset(2, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: Image.network('https://ychef.files.bbci.co.uk/live/624x351/p0973lkk.jpg', fit: BoxFit.fitWidth,),
            ),
            Positioned(
              top: 150,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("XX hiking club", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),),
                  Text("123 members", style: TextStyle(color: Colors.grey[300],),)
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
