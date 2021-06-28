import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Button extends StatefulWidget {
  final Widget? child;
  final void Function() onPressed;
  final bool invert;
  final Icon? icon;
  const Button(
      {Key? key,
      this.child,
      required this.onPressed,
      this.icon,
      this.invert = false})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  double _scale = 1;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1,
      duration: Duration(milliseconds: 150),
    );
    _controller.addListener(() {
      setState(() {
        _scale = _controller.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Transform.scale(
        scale: _scale,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 48,
            minWidth: 48,
            maxHeight: 48,
          ),
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: widget.icon != null ? 0 : 36),
            decoration: BoxDecoration(
                color: widget.invert
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(48))),
            child: DefaultTextStyle(
                style: TextStyle(color: Colors.white),
                child: Center(
                  widthFactor: 0,
                  child: widget.icon != null ? widget.icon : widget.child,
                )),
          ),
        ),
      ),
      onTap: () {
        _controller.reverse();
        widget.onPressed();
      },
      onTapDown: (dp) {
        _controller.reverse();
      },
      onTapUp: (dp) {
        Timer(Duration(milliseconds: 150), () {
          _controller.fling();
        });
      },
      onTapCancel: () {
        _controller.fling();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
