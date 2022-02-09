import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/utils/image.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.user, this.height = 32, this.onTap})
      : super(key: key);
  final FutureOr<User>? user;
  final double height;
  final void Function()? onTap;

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
          ? Shimmer(width: height, height: height)
          : user is Future<User>
              ? FutureBuilder<User>(
                  future: user as Future<User>,
                  builder: (context, snapshot) {
                    var user = snapshot.data;
                    if (user == null) {
                      return Shimmer(width: height, height: height);
                    }
                    return _avatar(user);
                  })
              : _avatar(user as User),
    );
  }

  Widget _avatar(User user) {
    var avatar = user.icon == null
        ? Container(
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(height / 2)),
          )
        : CachedNetworkImage(
            placeholder: (_, __) => Shimmer(),
            imageUrl: ImageUtils.imageLink(user.icon!),
            width: height,
            fit: BoxFit.cover,
          );
    return InkWell(
      onTap: () {
        if (onTap != null)
          onTap!();
        else
          Get.toNamed('/profiles/${user.id.toString()}');
      },
      child: avatar,
    );
  }
}
