import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionError extends StatelessWidget {
  const ConnectionError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('somethingWentWrong'.tr)));
  }
}
