import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';
import 'package:routemaster/routemaster.dart';

class DialogUtils {
  static show(context, Widget content,
      {String? title, List<Widget> Function(BuildContext)? buttons}) async {
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
                  if (title != null)...[
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ),
                    Divider(height: 1)
                  ],
                  Container(
                    padding: EdgeInsets.all(16),
                    child: content,
                  ),
                  if (buttons == null || buttons(context).length > 0)
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
                                  Routemaster.of(context).pop();
                                })
                        ],
                      ),
                    )
                ],
              ));
        });
  }
}
