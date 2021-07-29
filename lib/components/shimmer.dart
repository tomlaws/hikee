import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as S;

class Shimmer extends StatelessWidget {
  const Shimmer({Key? key, this.child, this.enabled = true}) : super(key: key);
  final Widget? child;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return S.Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: enabled,
        child: child ??
            Container(
              color: Colors.black54,
            ));
  }
}
