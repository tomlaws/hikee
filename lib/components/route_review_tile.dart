import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hikee/models/route_review.dart';

class RouteReviewTile extends StatelessWidget {
  const RouteReviewTile({Key? key, required this.routeReview})
      : super(key: key);
  final RouteReview routeReview;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    Container(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          routeReview.reviewer.nickname,
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        SizedBox(height: 4),
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
                        ),
                      ],
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 48),
                    child: Text(routeReview.content),
                  ),
                ],
              )),
            ],
          )
        ],
      ),
    );
  }
}
