import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikee/components/account/account_header.dart';
import 'package:hikee/components/protected.dart';
import 'package:get/get.dart';
import 'package:hikee/pages/account/account_controller.dart';
import 'package:hikee/themes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AccountPage extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Protected(
      authenticatedBuilder: (_, getMe) {
        return Scaffold(
          backgroundColor: Color(0xffffffff),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AccountHeader(
                      future: getMe,
                      onAvatarTap: () {
                        controller.promptUploadIcon();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        boxShadow: [Themes.lightShadow],
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Column(
                      children: [
                        MenuListTile(
                          onTap: () {
                            Get.toNamed('/records');
                          },
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
                          onTap: () {
                            Get.toNamed('/privacy');
                          },
                          title: "Privacy & Security",
                          icon: Icon(
                            LineAwesomeIcons.cogs,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                        MenuListTile(
                          onTap: () {
                            controller.logout();
                          },
                          title: "Logout",
                          icon: Icon(
                            LineAwesomeIcons.door_open,
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
  final Function? onTap;
  final Icon? icon;
  final bool switchValue;
  final bool? loading;
  final void Function(bool)? onSwitchValueChanged;
  const MenuListTile(
      {Key? key,
      required this.title,
      this.onTap,
      this.icon,
      this.switchValue = false,
      this.loading,
      this.onSwitchValueChanged})
      : super(key: key);

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
              height: 56,
              child: InkWell(
                onTap: () => {if (onTap != null) onTap!()},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        icon!,
                        Padding(padding: const EdgeInsets.only(right: 12)),
                      ],
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (onTap != null)
                        Icon(
                          LineAwesomeIcons.angle_right,
                          size: 24,
                          color: Colors.black26,
                        ),
                      if (onSwitchValueChanged != null)
                        loading == true
                            ? Container(
                                width: 16,
                                height: 16,
                                margin: EdgeInsets.only(
                                  right: 4,
                                ),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ))
                            : SizedBox(
                                height: 24,
                                child: Transform.scale(
                                  alignment: Alignment.centerRight,
                                  scale: 0.75,
                                  child: CupertinoSwitch(
                                      value: switchValue,
                                      onChanged: onSwitchValueChanged),
                                ),
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
