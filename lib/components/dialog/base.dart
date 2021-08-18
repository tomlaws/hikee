import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';
import 'package:routemaster/routemaster.dart';

abstract class BaseDialog extends StatefulWidget {
  const BaseDialog({Key? key}) : super(key: key);

  Widget build(BuildContext context, Widget content, List<Widget>? buttons) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: content,
              ),
              if (buttons == null || buttons.length > 0)
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      if (buttons != null)
                        ...buttons
                      else
                        Button(
                            child: Text('OK'),
                            onPressed: () {
                              Routemaster.of(context).pop();
                            })
                    ],
                  ),
                )
            ],
          ),
        ));
  }
}
