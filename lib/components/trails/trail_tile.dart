import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/pages/trail/trail_binding.dart';
import 'package:hikee/pages/trail/trail_page.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/image.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TrailTile extends StatelessWidget {
  final Trail? trail;
  final void Function()? onTap;
  final double width;
  final double aspectRatio;
  final double radius;
  const TrailTile(
      {Key? key,
      this.trail,
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
        if (trail != null)
          Get.toNamed(
            '/trails/${trail!.id}',
          );
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
                  child: trail == null
                      ? Shimmer()
                      : CachedNetworkImage(
                          placeholder: (_, __) => Shimmer(),
                          imageUrl: ImageUtils.imageLink(trail!.image),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    trail == null
                        ? Shimmer(fontSize: 16)
                        : Text(trail!.name,
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
                        trail == null
                            ? Shimmer(fontSize: 12, width: 88)
                            : Text(
                                trail!.region.name,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(LineAwesomeIcons.star,
                            color: Colors.black54, size: 12),
                        trail == null
                            ? Shimmer(fontSize: 12, width: 24)
                            : Text(
                                trail!.rating.toString(),
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
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
