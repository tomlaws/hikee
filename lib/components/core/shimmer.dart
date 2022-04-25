import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/utils/color.dart';
import 'package:shimmer/shimmer.dart' as S;

class Shimmer extends StatelessWidget {
  const Shimmer(
      {Key? key,
      this.child,
      this.enabled = true,
      this.width,
      this.height,
      this.expanded = false,
      this.radius,
      this.fontSize,
      this.color = const Color(0xFFFAFAFA)})
      : super(key: key);

  final Widget? child;
  final bool enabled;
  final double? width;
  final double? height;
  final bool expanded;
  final double? radius;
  final double? fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var renderHeight = height;
    if (height == null) {
      final Size size = (TextPainter(
              text: TextSpan(text: '', style: TextStyle(fontSize: fontSize)),
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;
      renderHeight = size.height;
    }
    return S.Shimmer.fromColors(
      baseColor: ColorUtils.darken(color, .1),
      highlightColor: color,
      enabled: enabled,
      child: child ??
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(radius ?? 12)),
            width: width,
            height: renderHeight,
          ),
    );
  }
}
