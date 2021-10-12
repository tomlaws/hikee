import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hikee/components/account/record_list_tile.dart';
import 'package:hikee/components/avatar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/components/protected.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/pages/account/account_controller.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AccountPage extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Protected(
      authenticatedBuilder: (_, getMe) {
        var me = getMe();
        return Scaffold(
          backgroundColor: Color(0xffffffff),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    GestureDetector(
                      onTap: () async {
                        controller.promptUploadIcon();
                      },
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        FutureBuilder<User>(
                            future: me,
                            builder: (_, snapshot) {
                              if (snapshot.data == null)
                                return Shimmer(
                                    height: 128, width: 128, radius: 64);
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
                                future: me,
                                builder: (_, snapshot) {
                                  if (snapshot.data == null)
                                    return Shimmer(
                                      fontSize: 24,
                                    );
                                  else
                                    return Text(
                                        snapshot.data?.nickname ?? 'Unnamed',
                                        style: TextStyle(fontSize: 24));
                                }),
                          ),
                        )
                      ]),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              LineAwesomeIcons.clock,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                            Padding(padding: const EdgeInsets.only(top: 8)),
                            Text(
                              '28',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 8)),
                            Text(
                              'hours',
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                letterSpacing: 1,
                                color: Colors.black26,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              LineAwesomeIcons.flag_1,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                            Padding(padding: const EdgeInsets.only(top: 8)),
                            Text(
                              '12',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 8)),
                            Text(
                              'events',
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                letterSpacing: 1,
                                color: Colors.black26,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              LineAwesomeIcons.map_pin,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                            Padding(padding: const EdgeInsets.only(top: 8)),
                            Text(
                              '18',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 8)),
                            Text(
                              'routes',
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                letterSpacing: 1,
                                color: Colors.black26,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              LineAwesomeIcons.walking,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                            Padding(padding: const EdgeInsets.only(top: 8)),
                            Text(
                              '23.5',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 8)),
                            Text(
                              'miles',
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                letterSpacing: 1,
                                color: Colors.black26,
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        MenuListTile(
                          onTap: () {},
                          title: "Records",
                          icon: Icon(
                            LineAwesomeIcons.trophy,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                        MenuListTile(
                          onTap: () {},
                          title: "Profile",
                          icon: Icon(
                            LineAwesomeIcons.user,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                        MenuListTile(
                          onTap: () {},
                          title: "Language",
                          icon: Icon(
                            LineAwesomeIcons.language,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                        MenuListTile(
                          onTap: () {},
                          title: "Privacy",
                          icon: Icon(
                            LineAwesomeIcons.cogs,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MenuListTile extends StatelessWidget {
  final String title;
  final Function onTap;
  final Icon icon;
  const MenuListTile({
    Key? key,
    required this.title,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Material(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(border: Border()),
              child: InkWell(
                onTap: () => {this.onTap()},
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  child: Row(
                    children: [
                      this.icon,
                      Padding(padding: const EdgeInsets.only(right: 12)),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        LineAwesomeIcons.angle_right,
                        size: 24,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
