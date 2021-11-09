import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/account/change_language.dart';
import 'package:hikee/components/account/change_nickname.dart';
import 'package:hikee/components/account/change_password.dart';
import 'package:hikee/components/avatar.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/controllers/shared/auth.dart';
import 'package:hikee/pages/account/account_controller.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatelessWidget {
  final controller = Get.find<AccountController>();
  final _authController = Get.put(AuthController());

  Map<String, dynamic> menu(bool loggedIn) {
    return {
      if (loggedIn) ...{
        'bookmarks'.tr: (BuildContext ctx) {
          // Get.to(LoginPage());
          // Navigator.of(ctx)
          //     .push(CupertinoPageTrail(builder: (_) => BookmarksPage()));
        },
        'events'.tr: (BuildContext ctx) {
          Get.toNamed('/events', id: 4);
        }
      } else
        'login'.tr: {
          //Trailmaster.of(context).push('/login');
        },
      if (loggedIn)
        'account'.tr: {
          'Change Nickname': _changeNickname,
          'Change Password': _changePassword,
          'Delete Account': (ctx) {}
        },
      'settings'.tr: {'language'.tr: _changeLanguage},
      if (loggedIn)
        'logout'.tr: (BuildContext ctx) {
          //ctx.read<AuthProvider>().logout();
        }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_authController.loggedIn.value == false) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            onPressed: () {
              Get.toNamed('/login');
            },
            child: Text('Login'),
          )
        ],
      );
    }
    controller.options.value.clear();
    controller.page.value = 0;
    var _menu = menu(_authController.loggedIn.value);
    _addToOptions(context, _menu);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          if (_authController.loggedIn.value) ...[
            Container(
              height: 16,
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image == null) return;
                  _uploadIcon(File(image.path));
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Obx(() => _authController.me.value != null
                      ? Avatar(
                          user: _authController.me.value!,
                          height: 128,
                        )
                      : CircularProgressIndicator())
                ]),
              ),
            ]),
            Container(
              height: 16,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 48,
                    child: Center(
                      child: Text(
                          _authController.me.value?.nickname ?? 'Unnamed',
                          style: TextStyle(fontSize: 24)),
                    ),
                  )
                ])
          ],
          _list(_menu)
        ],
      )),
    );
  }

  Widget _list(Map<String, dynamic> options) {
    return Obx(
      () {
        // calc height
        var left = controller.page.value.floor();
        var right = controller.page.value.ceil();
        var per = controller.page.value - left;
        var leftHeight = controller.options.value[left].children.length * 56;
        var rightHeight = controller.options.value[right].children.length * 56;
        var height = leftHeight + (rightHeight - leftHeight) * per;
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
                ]),
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(16),
            height: height,
            //duration: const Duration(milliseconds: 250),
            child: PageView(
                children: controller.options.value
                    .asMap()
                    .map((i, e) => MapEntry(
                        i,
                        Opacity(
                          opacity: (1 - (controller.page.value - i).abs())
                              .clamp(0, 1),
                          child: SingleChildScrollView(
                            child: e,
                          ),
                        )))
                    .values
                    .toList(),
                controller: controller.pageController));
      },
    );
  }

  void _addToOptions(BuildContext context, Map<String, dynamic> options,
      {String? header}) {
    controller.options.value = [
      ...controller.options.value,
      Column(
          children: [
        if (header != null) ...[
          DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: Divider.createBorderSide(context),
                ),
              ),
              child: ListTile(
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.all(0),
                minVerticalPadding: 0,
                leading: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Button(
                      icon: Icon(Icons.chevron_left),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        controller.pageController.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.linear);
                      }),
                ),
                title: Text(header, style: TextStyle()),
              ))
        ],
        ...ListTile.divideTiles(
            context: context,
            tiles: options.keys
                .map((key) => Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(key),
                        trailing: options[key] is Map
                            ? Icon(Icons.chevron_right)
                            : null,
                        onTap: () {
                          if (options[key] == null) {
                            return;
                          }
                          if (options[key] is Function) {
                            options[key](context);
                          }
                          if (options[key] is Map) {
                            _addToOptions(context, options[key], header: key);
                            controller.pageController.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.linear);
                          }
                        },
                      ),
                    ))
                .toList())
      ].toList())
    ];
  }

  void _changeNickname(BuildContext context) {
    DialogUtils.show(context, ChangeNickname(), title: 'Change Nickname',
        buttons: (_) {
      return [];
    });
  }

  void _changePassword(BuildContext context) {
    DialogUtils.show(context, ChangePassword(), title: 'Change Password',
        buttons: (_) {
      return [];
    });
  }

  void _uploadIcon(File file) {
    //context.read<MeProvider>().changeIcon(file);
  }

  void _changeLanguage(BuildContext context) {
    DialogUtils.show(context, ChangeLanguage(), title: 'language'.tr,
        buttons: (_) {
      return [];
    });
  }
}
