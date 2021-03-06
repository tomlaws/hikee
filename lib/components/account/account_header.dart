import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/avatar.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/models/user.dart';
import 'package:hikees/themes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AccountHeader extends GetView {
  const AccountHeader({this.user, this.onAvatarTap, this.updatingIcon = false});
  final User? user;
  final void Function()? onAvatarTap;
  final bool updatingIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 32,
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            Avatar(
              user: updatingIcon ? null : user,
              height: 128,
              onTap: onAvatarTap,
            )
          ]),
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 48,
                child: Center(
                    child: user == null
                        ? Shimmer(
                            fontSize: 24,
                            width: 90,
                          )
                        : Text(user?.nickname ?? 'unnamed'.tr,
                            style: TextStyle(fontSize: 24))),
              )
            ]),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
              boxShadow: [Themes.lightShadow]),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Icon(
                          LineAwesomeIcons.clock,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        user == null
                            ? Shimmer(
                                fontSize: 20,
                              )
                            : Text(
                                (user!.minutes! / 60).floor().toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Text(
                          'hours'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1,
                            color: Colors.black38,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 64,
                  color: Colors.black12,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Icon(
                          LineAwesomeIcons.route,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        user == null
                            ? Shimmer(
                                fontSize: 20,
                              )
                            : Text(
                                (user!.trailCount!).floor().toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Text(
                          'trails'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1,
                            color: Colors.black38,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 64,
                  color: Colors.black12,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Icon(
                          LineAwesomeIcons.walking,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        user == null
                            ? Shimmer(
                                fontSize: 20,
                              )
                            : Text(
                                (user!.meters! * 0.0006213712)
                                    .toStringAsFixed(1)
                                    .replaceFirst('.0', ''),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Text(
                          'miles'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1,
                            color: Colors.black38,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 64,
                  color: Colors.black12,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Icon(
                          LineAwesomeIcons.flag_1,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        user == null
                            ? Shimmer(
                                fontSize: 20,
                              )
                            : Text(
                                user!.eventCount.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Text(
                          'events'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1,
                            color: Colors.black38,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}
