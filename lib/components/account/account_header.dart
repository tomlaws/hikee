import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/avatar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/themes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AccountHeader extends GetView {
  const AccountHeader({required this.future});
  final Future<User> future;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 32,
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
            onTap: () async {
              controller.promptUploadIcon();
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              FutureBuilder<User>(
                  future: future,
                  builder: (_, snapshot) {
                    if (snapshot.data == null)
                      return Shimmer(height: 128, width: 128, radius: 64);
                    else
                      return Avatar(
                        user: snapshot.data!,
                        height: 128,
                      );
                  })
            ]),
          ),
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 48,
                child: Center(
                  child: FutureBuilder<User>(
                      future: future,
                      builder: (_, snapshot) {
                        if (snapshot.data == null)
                          return Shimmer(
                            fontSize: 24,
                          );
                        else
                          return Text(snapshot.data?.nickname ?? 'Unnamed',
                              style: TextStyle(fontSize: 24));
                      }),
                ),
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
                        FutureBuilder<User>(
                            future: future,
                            builder: (_, snapshot) {
                              if (snapshot.data == null)
                                return Shimmer(
                                  fontSize: 20,
                                );
                              else
                                return Text(
                                  (snapshot.data!.minutes! / 60)
                                      .floor()
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                );
                            }),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Text(
                          'hours',
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
                          LineAwesomeIcons.map_pin,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        FutureBuilder<User>(
                            future: future,
                            builder: (_, snapshot) {
                              if (snapshot.data == null)
                                return Shimmer(
                                  fontSize: 20,
                                );
                              else
                                return Text(
                                  (snapshot.data!.trailCount!)
                                      .floor()
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                );
                            }),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Text(
                          'trails',
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
                        FutureBuilder<User>(
                            future: future,
                            builder: (_, snapshot) {
                              if (snapshot.data == null)
                                return Shimmer(
                                  fontSize: 20,
                                );
                              else
                                return Text(
                                  (snapshot.data!.meters! * 0.0006213712)
                                      .toStringAsFixed(1)
                                      .replaceFirst('.0', ''),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                );
                            }),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Text(
                          'miles',
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
                        FutureBuilder<User>(
                            future: future,
                            builder: (_, snapshot) {
                              if (snapshot.data == null)
                                return Shimmer(
                                  fontSize: 20,
                                );
                              else
                                return Text(
                                  snapshot.data!.eventCount.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                );
                            }),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Text(
                          'events',
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
