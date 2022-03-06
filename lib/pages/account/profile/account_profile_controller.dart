import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/user.dart';
import 'package:hikee/utils/dialog.dart';

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

  Future<void> updateNickname() async {
    final formkey = GlobalKey<FormState>();
    var nickname = '';
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
                    return 'fieldCannotBeEmpty'
                        .trParams({'field': 'nickname'.tr});
                  }
                  if (v.length > 16) {
                    return 'fieldTooLong'.trParams({'field': 'nickname'.tr});
                  }
                  if (v.length < 4) {
                    return 'fieldTooShort'.trParams({'field': 'nickname'.tr});
                  }
                  return null;
                },
              ),
            ],
          ),
        ), onOk: () async {
      if (formkey.currentState?.validate() == true) {
        formkey.currentState?.save();
        final result = await userProvider.update(nickname: nickname);
        return true;
      } else {
        throw new Error();
      }
    });
    _authProvider.refreshMe();
  }
}
