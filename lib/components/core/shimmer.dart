import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as S;

class Shimmer extends StatelessWidget {
  const Shimmer(
      {Key? key,
      this.child,
      this.enabled = true,
      this.width,
      this.height = 17.5,
      this.radius,
      this.fontSize})
      : super(key: key);

  final Widget? child;
  final bool enabled;
  final double? width;
  final double height;
  final double? radius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    var renderHeight = height;
    if (fontSize != null) {
      renderHeight = fontSize! + fontSize! / 4;
    }
    return S.Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.grey[50]!,
      enabled: enabled,
      child: child ??
          Container(
            constraints: width == null && renderHeight == null
                ? BoxConstraints.expand()
                : null,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(radius ?? 8)),
            width: width,
            height: renderHeight,
          ),
    );
  }
}
