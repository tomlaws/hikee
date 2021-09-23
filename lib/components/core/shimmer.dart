import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as S;

class Shimmer extends StatelessWidget {
  const Shimmer(
      {Key? key, this.child, this.enabled = true, this.width, this.height})
      : super(key: key);

  final Widget? child;
  final bool enabled;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return S.Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.grey[50]!,
      enabled: enabled,
      child: child ??
          Container(
            constraints: width == null && height == null
                ? BoxConstraints.expand()
                : null,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(8)),
            width: width,
            height: height,
          ),
    );
  }
}
