import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Button extends StatefulWidget {
  final Widget? child;
  final void Function() onPressed;
  final bool invert;
  final Color? backgroundColor;
  final bool loading;
  final bool disabled;
  final Icon? icon;
  const Button(
      {Key? key,
      this.child,
      required this.onPressed,
      this.icon,
      this.backgroundColor,
      this.loading = false,
      this.disabled = false,
      this.invert = false})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  double _scale = 1;
  late AnimationController _controller;
  Timer? _timer;

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
                EdgeInsets.symmetric(horizontal: widget.icon != null ? 0 : 16),
            decoration: BoxDecoration(
                color: (widget.backgroundColor != null
                        ? widget.backgroundColor!
                        : (widget.invert
                            ? Colors.white
                            : Theme.of(context).primaryColor))
                    .withOpacity((widget.disabled || widget.loading) ? .75 : 1),
                borderRadius: BorderRadius.all(Radius.circular(32))),
            child: DefaultTextStyle(
                style: TextStyle(
                    color: (widget.invert
                            ? Theme.of(context).primaryColor
                            : Colors.white)
                        .withOpacity(
                            (widget.disabled || widget.loading) ? .75 : 1),
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5),
                child: Stack(alignment: Alignment.center, children: [
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: widget.loading ? 1 : 0,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
                  Opacity(
                    opacity: widget.loading ? 0 : 1,
                    child: (widget.icon != null ? widget.icon : widget.child) ??
                        SizedBox(),
                  )
                ])),
          ),
        ),
      ),
      onTap: () {
        if (widget.loading || widget.disabled) return;
        _controller.reverse();
        widget.onPressed();
      },
      onTapDown: (dp) {
        if (widget.loading || widget.disabled) return;
        _controller.reverse();
      },
      onTapUp: (dp) {
        if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
        _timer = Timer(Duration(milliseconds: 150), () {
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
    if (_timer != null) _timer!.cancel();
    _controller.dispose();
    super.dispose();
  }
}
