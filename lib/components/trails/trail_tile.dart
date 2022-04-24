import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/custom_ink_well.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/themes.dart';
import 'package:hikees/utils/image.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TrailTile extends StatelessWidget {
  final Trail? trail;
  final void Function()? onTap;
  final double width;
  final double aspectRatio;
  final double radius;
  final bool offline;
  const TrailTile(
      {Key? key,
      this.trail,
      this.onTap,
      this.width = double.infinity,
      this.radius = 16,
      this.aspectRatio = 16 / 9,
      this.offline = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [Themes.shadow]),
        child: Material(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: CustomInkWell(
            onTap: () {
              if (onTap != null) {
                onTap!();
                return;
              }
              if (trail != null)
                Get.toNamed('/trails/${trail!.id}',
                    arguments: offline ? {'trail': trail} : null);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (offline)
                  SizedBox(height: 8)
                else
                  AspectRatio(
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
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 4, left: 16, right: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        trail == null
                            ? Shimmer(fontSize: 16)
                            : Text(trail!.name,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            Icon(LineAwesomeIcons.map_marker,
                                color: Colors.black54, size: 12),
                            trail == null
                                ? Shimmer(fontSize: 12, width: 64)
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
                                ? Shimmer(fontSize: 12, width: 16)
                                : Text(
                                    trail!.difficulty.toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(LineAwesomeIcons.heart,
                                color: Colors.black54, size: 12),
                            trail == null
                                ? Shimmer(fontSize: 12, width: 16)
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
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
