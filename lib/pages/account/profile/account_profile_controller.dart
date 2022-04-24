import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/user.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/providers/user.dart';
import 'package:hikees/utils/dialog.dart';

class AccountProfileController extends GetxController {
  final userProvider = Get.put(UserProvider());
  final _authProvider = Get.find<AuthProvider>();
  final isPrivate = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  get user {
    return _authProvider.me.value;
  }

  @override
  void onClose() {
    super.onClose();
  }

  final formkey = GlobalKey<FormState>();
  Future<void> updateNickname() async {
    var nickname = '';
    String? nicknameError;
    await DialogUtils.showActionDialog(
        'updateNickname'.tr,
        Form(
          key: formkey,
          child: Column(
            children: [
              TextInput(
                label: 'nickname'.tr,
                hintText: 'nickname'.tr,
                onSaved: (v) => nickname = v ?? '',
                validator: (v) {
                  if (v == null || v.length == 0) {
                    return 'fieldCannotBeEmpty'.trArgs(['nickname'.tr]);
                  }
                  return nicknameError;
                },
              ),
            ],
          ),
        ),
        errorMapping: {
          'nickname': (msg) {
            nicknameError = msg;
            formkey.currentState?.validate();
          }
        }, onOk: () async {
      nicknameError = null;
      if (formkey.currentState?.validate() == true) {
        formkey.currentState?.save();

        final auth = Get.find<AuthProvider>();
        if (nickname.toLowerCase() == auth.me.value?.nickname.toLowerCase()) {
          return true;
        }
        print(nickname);
        final result = await userProvider.update(nickname: nickname);
        return true;
      } else {
        throw new Error();
      }
    });
    _authProvider.refreshMe();
  }
}
