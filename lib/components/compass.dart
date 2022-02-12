import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';

class Compass extends StatefulWidget {
  const Compass({Key? key, required this.heading}) : super(key: key);

  @override
  _CompassState createState() => _CompassState();

  final Rxn<LocationMarkerHeading> heading;
}

class _CompassState extends State<Compass> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late Tween<double> _tween;
  late AnimationController _animationController;
  double? lastValue;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _tween = Tween(begin: 0.0, end: 0.0);
    _animation = _tween.animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.black26, fontSize: 12),
      child: Obx(() {
        if (widget.heading.value == null) return SizedBox();

        if (lastValue != widget.heading.value!.heading) {
          lastValue = widget.heading.value!.heading;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            _tween.begin = _tween.end;
            _animationController.reset();
            _tween.end = -widget.heading.value!.heading;
            _animationController.forward();
          });
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(96),
                    color: Colors.black.withOpacity(.1)),
              ),
            ),
            Transform.rotate(
                angle: _animation.value,
                child: ClipPath(
                  clipper: PointerClipper(),
                  child: Container(
                    width: 10,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.5, 0.5],
                          colors: [Colors.red.shade400, Colors.white]),
                    ),
                  ),
                )),
            Positioned(
                child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade400, width: 2.0)),
            )),
          ],
        );
      }),
    );
  }
}

class PointerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
