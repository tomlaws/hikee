import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hikee/models/route.dart';

class HikingRouteTile extends StatefulWidget {
  final HikingRoute route;
  final void Function()? onTap;
  const HikingRouteTile({Key? key, required this.route, this.onTap})
      : super(key: key);

  @override
  _HikingRouteTileState createState() => _HikingRouteTileState();
}

class _HikingRouteTileState extends State<HikingRouteTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          margin: EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                child: Image.network(
                  widget.route.image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 88,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(.7),
                      ],)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.route.name_en,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            widget.route.district_en,
                            maxLines: 1,
                            style:
                                TextStyle(color: Color(0xFFCCCCCC)),
                          ),
                          Container(
                            height: 16,
                            child: RatingBar.builder(
                              itemSize: 16,
                              initialRating: widget.route.rating,
                              allowHalfRating: true,
                              itemCount: 5,
                              unratedColor: Colors.white.withOpacity(.5),
                              itemPadding: EdgeInsets.only(right: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              ignoreGestures: true,
                              onRatingUpdate: (double value) {},
                            ),
                          )
                        ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
