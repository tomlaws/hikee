import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, required this.child, this.padding = true})
      : super(key: key);
  final Widget child;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ? EdgeInsets.all(16) : null,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 16,
            spreadRadius: -8,
            color: Colors.black.withOpacity(.09),
            offset: Offset(0, -6))
      ]),
      child: child,
    );
  }
}
