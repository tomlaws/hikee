import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/dialog/base.dart';

class DialogUtils {
  static show(context, Widget content,
      {String? title,
      List<Widget> Function(BuildContext)? buttons,
      BaseDialog? template}) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.1), blurRadius: 3),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (title != null) ...[
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 12),
                            child: Text(title,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        //Divider(height: 1)
                      ],
                      Container(
                        padding: EdgeInsets.all(16),
                        child: content,
                      ),
                      if (buttons == null || buttons(context).length > 0)
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                  ),
                ),
              ));
        });
  }

  static template(BuildContext context, Widget template) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return template;
        });
  }
}
