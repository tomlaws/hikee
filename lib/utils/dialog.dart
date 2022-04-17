import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';

class DialogUtils {
  static Future<dynamic> showDialog(String title, dynamic content,
      {String? dismissText, bool showDismiss = true, Function? onDismiss}) {
    return Get.defaultDialog(
        title: title,
        titlePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        //barrierDismissible: false,
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: content is Widget
                  ? content
                  : Text(
                      content,
                      style: TextStyle(color: Colors.black),
                    ),
            ),
            if (showDismiss)
              SizedBox(
                height: 16,
              ),
            if (showDismiss)
              Button(
                secondary: true,
                onPressed: () {
                  if (onDismiss != null) onDismiss();
                  Get.back();
                },
                child: Text(dismissText ?? 'dismiss'.tr),
              )
          ],
        ));
  }

  static Future<T?> showActionDialog<T>(String title, Widget content,
      {Function? onOk,
      Function? onCancel,
      String? okText,
      String? cancelText,
      bool mutate = true}) async {
    final _loading = false.obs;
    return await Get.defaultDialog(
        title: title,
        titlePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        //barrierDismissible: false,
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: content,
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Button(
                      secondary: true,
                      backgroundColor: onCancel != null ? Colors.red : null,
                      onPressed: () async {
                        if (onCancel != null) {
                          return await onCancel();
                        }
                        Get.back();
                      },
                      child: Text(
                          cancelText ?? (mutate ? 'cancel'.tr : 'dismiss'.tr)),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: Obx(
                    () => Button(
                      loading: _loading.value,
                      onPressed: () async {
                        if (onOk != null) {
                          try {
                            _loading.value = true;
                            var result = await onOk();
                            if (result != null) Get.back(result: result);
                            _loading.value = false;
                          } catch (ex) {
                            _loading.value = false;
                            print(ex);
                          }
                        } else {
                          Get.back();
                          _loading.value = false;
                        }
                      },
                      child: Text(okText ?? (mutate ? 'submit'.tr : 'ok'.tr)),
                    ),
                  ))
                ],
              ),
            )
          ],
        ));
  }
}
