import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/core/mutation_builder.dart';

class DialogUtils {
  static showDialog(String title, dynamic content, {bool showDismiss = true}) {
    Get.defaultDialog(
        title: title,
        titlePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
                  Get.back();
                },
                child: Text('Dismiss'),
              )
          ],
        ));
  }

  static Future<T?> showActionDialog<T>(String title, Widget content,
      {Function? onOk, bool mutate = true}) async {
    final _loading = false.obs;
    return await Get.defaultDialog(
        title: title,
        titlePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: content,
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Button(
                      secondary: true,
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(mutate ? 'Cancel' : 'Dismiss'),
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
                            Get.back(result: result);
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
                      child: Text(mutate ? 'Submit' : 'OK'),
                    ),
                  ))
                ],
              ),
            )
          ],
        ));
  }
}
