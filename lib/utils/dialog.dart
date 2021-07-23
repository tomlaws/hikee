import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';

class DialogUtils {
  static show(context, Widget content,
      {List<Button> Function(BuildContext)? buttons}) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: content,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        if (buttons != null)
                          ...buttons(context)
                        else
                          Button(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                      ],
                    ),
                  )
                ],
              ));
        });
  }
}
