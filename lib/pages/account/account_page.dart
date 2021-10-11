import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hikee/components/avatar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/components/protected.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/pages/account/account_controller.dart';

class AccountPage extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Protected(
      authenticatedBuilder: (_, getMe) {
        var me = getMe();
        return SingleChildScrollView(
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
                    ])
              ],
            ),
          ),
        );
      },
    );
  }
}
