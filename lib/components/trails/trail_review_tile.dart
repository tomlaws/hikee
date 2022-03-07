import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hikees/components/core/avatar.dart';
import 'package:hikees/models/trail_review.dart';
import 'package:hikees/themes.dart';

class TrailReviewTile extends StatelessWidget {
  const TrailReviewTile(
      {Key? key, required this.trailReview, this.contained = true})
      : super(key: key);
  final TrailReview trailReview;
  final bool contained;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: contained ? EdgeInsets.all(16.0) : null,
      decoration: contained
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [Themes.lightShadow],
              borderRadius: BorderRadius.circular(16.0))
          : null,
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
                    Avatar(
                      user: trailReview.reviewer,
                    ),
                    Container(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(trailReview.reviewer.nickname,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        RatingBar.builder(
                          itemSize: 16,
                          initialRating: trailReview.rating.toDouble(),
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
                    padding:
                        const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 48),
                    child: Text(trailReview.content),
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
