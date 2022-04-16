import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikees/components/account/account_header.dart';
import 'package:get/get.dart';
import 'package:hikees/pages/account/account_controller.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/themes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AccountPage extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Get.put(AuthProvider());
    final content = SafeArea(
      child: Obx(
        () => Column(
          children: [
            if (authProvider.loggedIn.value)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() => AccountHeader(
                      user: controller.user.value,
                      onAvatarTap: () {
                        controller.promptUploadIcon();
                      },
                    )),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(16).copyWith(top: 8),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [Themes.boxShadow],
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (authProvider.loggedIn.value) ...[
                        MenuListTile(
                          onTap: () {
                            Get.toNamed('/profile');
                          },
                          title: "profile".tr,
                          icon: Icon(
                            LineAwesomeIcons.user,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                        MenuListTile(
                          onTap: () {
                            Get.toNamed('/records');
                          },
                          title: "records".tr,
                          icon: Icon(
                            LineAwesomeIcons.trophy,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                        MenuListTile(
                          onTap: () {
                            Get.toNamed('/bookmarks');
                          },
                          title: "bookmarks".tr,
                          icon: Icon(
                            LineAwesomeIcons.bookmark,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                        MenuListTile(
                          onTap: () {
                            Get.toNamed('/privacy');
                          },
                          title: "privacyAndSecurity".tr,
                          icon: Icon(
                            LineAwesomeIcons.user_secret,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                      if (authProvider.loggedIn.value)
                        MenuListTile(
                          onTap: () {
                            controller.logout();
                          },
                          title: "logout".tr,
                          icon: Icon(
                            LineAwesomeIcons.door_open,
                            size: 32,
                            color: Colors.black26,
                          ),
                        )
                      else
                        MenuListTile(
                          onTap: () {
                            Get.toNamed('/login');
                          },
                          title: 'login'.tr,
                          icon: Icon(
                            LineAwesomeIcons.door_closed,
                            size: 32,
                            color: Colors.black26,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16).copyWith(top: 8),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      boxShadow: [Themes.boxShadow],
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Column(
                    children: [
                      MenuListTile(
                        onTap: () {
                          Get.toNamed('/saved-records');
                        },
                        title: "savedRecords".tr,
                        icon: Icon(
                          LineAwesomeIcons.history,
                          size: 32,
                          color: Colors.black26,
                        ),
                      ),
                      MenuListTile(
                        onTap: () {
                          Get.toNamed('/offline-trails');
                        },
                        title: "offlineTrails".tr,
                        icon: Icon(
                          LineAwesomeIcons.route,
                          size: 32,
                          color: Colors.black26,
                        ),
                      ),
                      // MenuListTile(
                      //   onTap: () {
                      //     Get.toNamed('/offline-trails');
                      //   },
                      //   title: "savedRecords".tr,
                      //   icon: Icon(
                      //     LineAwesomeIcons.route,
                      //     size: 32,
                      //     color: Colors.black26,
                      //   ),
                      // ),
                      MenuListTile(
                        onTap: () {
                          Get.toNamed('/preferences');
                        },
                        title: "preferences".tr,
                        icon: Icon(
                          LineAwesomeIcons.horizontal_sliders,
                          size: 32,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Obx(() {
        if (authProvider.loggedIn.value)
          return RefreshIndicator(
            onRefresh: () async {
              controller.refreshAccount();
            },
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: content),
          );
        else
          return Column(children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: content,
              ),
            ),
          ]);
      }),
    );
  }
}

class MenuListTile extends StatelessWidget {
  final String title;
  final Function? onTap;
  final Icon? icon;
  final Widget? trailing;
  final bool switchValue;
  final bool? loading;
  final void Function(bool)? onSwitchValueChanged;
  const MenuListTile(
      {Key? key,
      required this.title,
      this.onTap,
      this.icon,
      this.trailing,
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
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (onTap != null)
                        if (trailing != null)
                          Expanded(
                            flex: 1,
                            child: DefaultTextStyle(
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38,
                                ),
                                child: trailing!),
                          )
                        else
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
