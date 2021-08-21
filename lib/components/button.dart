import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Button extends StatefulWidget {
  final Widget? child;
  final void Function() onPressed;
  final bool invert;
  final Color? backgroundColor;
  final bool secondary;
  final bool loading;
  final bool disabled;
  final Icon? icon;
  const Button(
      {Key? key,
      this.child,
      required this.onPressed,
      this.icon,
      this.backgroundColor,
      this.secondary = false,
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
    var buttonColor = (widget.backgroundColor != null
        ? widget.backgroundColor!
        : (widget.invert
            ? Colors.white
            : (widget.secondary
                ? Color(0xFFF5F5F5)
                : Theme.of(context).primaryColor)));
    var textColor =
        (widget.invert ? Theme.of(context).primaryColor : Colors.white)
            .withOpacity((widget.disabled || widget.loading) ? .75 : 1);
    if (widget.secondary)
      textColor = Theme.of(context).textTheme.bodyText1!.color!;
    if (buttonColor != Colors.transparent)
      buttonColor.withOpacity((widget.disabled || widget.loading) ? .75 : 1);
    return Material(
      borderRadius: BorderRadius.circular(12.0),
      clipBehavior: Clip.antiAlias,
      color: buttonColor,
      child: InkWell(
        onTap: () {
          widget.onPressed();
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 40,
            minWidth: 48,
            maxHeight: 40,
          ),
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: widget.icon != null ? 0 : 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: DefaultTextStyle(
                style: TextStyle(
                    color: textColor,
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
    );
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    _controller.dispose();
    super.dispose();
  }
}
