import 'package:flutter/material.dart';
import 'package:hikees/themes.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, required this.child, this.padding = true})
      : super(key: key);
  final Widget child;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ? EdgeInsets.all(16) : null,
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: [Themes.bottomBarShadow]),
      child: SafeArea(
        child: child,
        top: false,
      ),
    );
  }
}
