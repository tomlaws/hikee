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
                height: 24,
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
      {Function? onOk, MutationBuilder? mutationBuilder}) async {
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
              height: 24,
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
                      child:
                          Text(mutationBuilder != null ? 'Cancel' : 'Dismiss'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Button(
                      onPressed: () async {
                        if (onOk != null) {
                          var result = await onOk();
                          Get.back();
                          return result;
                        } else {
                          Get.back();
                        }
                      },
                      child: Text(mutationBuilder != null ? 'Submit' : 'OK'),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
