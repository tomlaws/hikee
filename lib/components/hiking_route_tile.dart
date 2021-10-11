import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/pages/route/route_binding.dart';
import 'package:hikee/pages/route/route_page.dart';

class HikingRouteTile extends StatelessWidget {
  final HikingRoute route;
  final void Function()? onTap;
  final double width;
  final double aspectRatio;
  final double radius;
  const HikingRouteTile(
      {Key? key,
      required this.route,
      this.onTap,
      this.width = double.infinity,
      this.radius = 8,
      this.aspectRatio = 16 / 9})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
          return;
        }
        Get.toNamed(
          '/routes/${route.id}',
        );
        //Get.toNamed('/route', id: 1, arguments: {'id': route.id});
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: width,
          clipBehavior: Clip.antiAlias,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(radius)),
          child: AspectRatio(
            //height: 180,
            //width: width,
            aspectRatio: aspectRatio,
            child: CachedNetworkImage(
              placeholder: (_, __) => Shimmer(),
              imageUrl: route.image,
              imageBuilder: (_, image) {
                return Stack(children: [
                  Positioned.fill(
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'route-${route.id}-image',
                      child: Image(
                        image: image,
                        fit: BoxFit.cover,
                      ),
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
                        ],
                      )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(route.name_en,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                route.region.name_en,
                                maxLines: 1,
                                style: TextStyle(color: Color(0xFFCCCCCC)),
                              ),
                              Container(
                                height: 16,
                                child: RatingBar.builder(
                                  itemSize: 16,
                                  initialRating: route.rating.toDouble(),
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
                ]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}
