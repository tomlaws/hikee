import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/models/user.dart';
import 'package:hikees/providers/auth.dart';

class Protected extends StatelessWidget {
  final Widget Function(BuildContext context)? unauthenticatedBuilder;
  final Widget Function(BuildContext context, Future<User> getMe)
      authenticatedBuilder;
  Protected({this.unauthenticatedBuilder, required this.authenticatedBuilder});

  @override
  Widget build(BuildContext context) {
    final authProvider = Get.put(AuthProvider());
    return Obx(() {
      if (authProvider.loggedIn.value) {
        return SizedBox();
        //var getMe = authProvider.getMe();
        //return authenticatedBuilder(context, getMe);
      } else {
        if (unauthenticatedBuilder != null) {
          return unauthenticatedBuilder!(context);
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login to enjoy hiking'.tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Container(height: 32),
            SizedBox(
              width: 200,
              child: Button(
                  child: Text('loing'.tr),
                  onPressed: () {
                    Get.toNamed('/login');
                  }),
            )
          ],
        );
      }
    });
  }
}
