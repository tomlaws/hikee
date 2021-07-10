import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LibraryCard extends StatelessWidget{
  const LibraryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
//      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(24),
              offset: Offset(0, 3),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: AspectRatio(
                  aspectRatio: 21/9,
                  child: Image.network('https://www.planetware.com/photos-large/HK/china-hong-kong-dragons-back-trail-overview.jpg', fit: BoxFit.fill,),
                ),
              ),

              Positioned(
                  top: 2,
                  right: 2,
                  child: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.grey, size: 25),
                    onPressed: (){},
                  ))
            ],
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hiking Trials",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
                Text("District",
                    style: TextStyle(color: Colors.grey[600], fontSize: 18)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text("Difficulty:", style: TextStyle(color: Colors.grey[600], fontSize: 18),),
                      Icon(Icons.star, color: Colors.orangeAccent, size: 18),
                      Icon(Icons.star, color: Colors.orangeAccent, size: 18),
                      Icon(Icons.star_border, color: Colors.orangeAccent, size: 18)
                    ],),
                    Text("Length: 13.5 km", style: TextStyle(color: Colors.grey[600], fontSize: 18),)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}