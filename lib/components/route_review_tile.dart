import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hikee/models/route_review.dart';

class RouteReviewTile extends StatelessWidget {
  const RouteReviewTile({Key? key, required this.routeReview})
      : super(key: key);
  final RouteReview routeReview;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(routeReview.content),
            RatingBar.builder(
              itemSize: 16,
              initialRating: routeReview.rating.toDouble(),
              allowHalfRating: false,
              itemCount: 5,
              unratedColor: Colors.grey,
              itemPadding: EdgeInsets.only(right: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              ignoreGestures: true,
              onRatingUpdate: (double value) {},
            )
          ],
        )
      ],
    );
  }
}
