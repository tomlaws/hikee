import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/user.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.user, this.height = 32}) : super(key: key);
  final User? user;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: height,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2.0),
            color: Colors.white),
        child: user == null
            ? Shimmer()
            : user!.icon == null
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(height / 2)),
                  )
                : CachedNetworkImage(
                    placeholder: (_, __) => Shimmer(),
                    imageUrl:
                        'https://hikee.s3.ap-southeast-1.amazonaws.com/${user!.icon!}',
                    width: height,
                    fit: BoxFit.cover,
                  ));
  }
}
