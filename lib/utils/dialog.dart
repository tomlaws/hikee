import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/mutation_builder.dart';

class DialogUtils {
  static Future<dynamic> showSimpleDialog(String title, dynamic content,
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
      bool mutate = true,
      bool critical = false}) async {
    return await showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
              actionsPadding:
                  EdgeInsets.only(left: 16.0, bottom: 12, top: 12, right: 16),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Button(
                  secondary: true,
                  backgroundColor: onCancel != null ? Colors.red : null,
                  onPressed: () async {
                    if (onCancel != null) {
                      return await onCancel();
                    }
                    Get.back();
                  },
                  child:
                      Text(cancelText ?? (mutate ? 'cancel'.tr : 'dismiss'.tr)),
                ),
                MutationBuilder(mutation: () async {
                  if (onOk != null) return await onOk();
                  return null;
                }, onDone: (result) {
                  if (result != null) {
                    Get.back(result: result);
                  } else {
                    Get.back();
                  }
                }, builder: (_mutate, loading) {
                  return Button(
                    loading: loading,
                    backgroundColor: critical ? Colors.red : null,
                    onPressed: _mutate,
                    child: Text(okText ?? (mutate ? 'submit'.tr : 'ok'.tr)),
                  );
                })
              ],
              content: content,
            ));
  }
}
