import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionButton extends StatelessWidget {
  SectionButton({
    required this.text,
    this.textAlignment = Alignment.centerRight,
    this.iconData,
    this.color,
    this.textColor,
    this.background,
  });
  final String text;
  final AlignmentGeometry textAlignment;
  final IconData? iconData;
  final Color? color;
  final Color? textColor;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: color ?? Colors.grey[100],
          borderRadius: BorderRadius.circular(8)),
      child: Stack(clipBehavior: Clip.none, children: [
        if (background == null)
          Positioned(
            left: 0,
            top: 0,
            child: Icon(
              iconData,
              size: 72,
              color: Colors.black12,
            ),
          )
        else
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: 0,
            child: background!,
          ),
        Align(
          alignment: textAlignment,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.black38),
            ),
          ),
        )
      ]),
    );
  }
}
