import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/pages/route/route_binding.dart';
import 'package:hikee/pages/route/route_page.dart';
import 'package:hikee/themes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
      this.radius = 16,
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
      child: Container(
          width: width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [Themes.shadow]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                //height: 180,
                //width: width,
                aspectRatio: aspectRatio,
                child: Container(
                  margin: EdgeInsets.all(8),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (_, __) => Shimmer(),
                    imageUrl: route.image, fit: BoxFit.cover,
                    // imageBuilder: (_, image) {
                    //   return Stack(children: [
                    //     Positioned.fill(
                    //       child: Image(
                    //         image: image,
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //     Positioned(
                    //       bottom: 0,
                    //       left: 0,
                    //       right: 0,
                    //       child: Container(
                    //         height: 88,
                    //         decoration: BoxDecoration(
                    //             gradient: LinearGradient(
                    //           begin: Alignment.topCenter,
                    //           end: Alignment.bottomCenter,
                    //           colors: [
                    //             Colors.transparent,
                    //             Colors.black.withOpacity(.7),
                    //           ],
                    //         )),
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //               vertical: 12.0, horizontal: 12),
                    //           child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Container(
                    //                   height: 16,
                    //                   child: RatingBar.builder(
                    //                     itemSize: 16,
                    //                     initialRating: route.rating.toDouble(),
                    //                     allowHalfRating: true,
                    //                     itemCount: 5,
                    //                     unratedColor:
                    //                         Colors.white.withOpacity(.5),
                    //                     itemPadding:
                    //                         EdgeInsets.only(right: 4.0),
                    //                     itemBuilder: (context, _) => Icon(
                    //                       Icons.star,
                    //                       color: Colors.amber,
                    //                     ),
                    //                     ignoreGestures: true,
                    //                     onRatingUpdate: (double value) {},
                    //                   ),
                    //                 )
                    //               ]),
                    //         ),
                    //       ),
                    //     )
                    //   ]);
                    // },
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(route.name_en,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        Icon(LineAwesomeIcons.map_marker,
                            color: Colors.black54, size: 12),
                        Text(
                          route.region.name_en,
                          maxLines: 1,
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(LineAwesomeIcons.star,
                            color: Colors.black54, size: 12),
                        Text(
                          route.rating.toString(),
                          maxLines: 1,
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
