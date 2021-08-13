import 'package:flutter/material.dart';

class HikeeAppBar extends StatelessWidget {
  const HikeeAppBar({Key? key, required this.title}) : super(key: key);
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black54,
      titleSpacing: 0
    );
  }
}
