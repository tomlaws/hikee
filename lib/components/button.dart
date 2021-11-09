import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikee/themes.dart';

class Button extends StatefulWidget {
  final Widget? child;
  final void Function() onPressed;
  final bool invert;
  final Color? backgroundColor;
  final bool secondary;
  final bool loading;
  final bool disabled;
  final Icon? icon;
  final double radius;
  final double minWidth;
  final double height;
  final bool shadow;
  final EdgeInsets? padding;
  final bool safeArea;

  const Button(
      {Key? key,
      this.child,
      required this.onPressed,
      this.icon,
      this.backgroundColor,
      this.secondary = false,
      this.loading = false,
      this.disabled = false,
      this.invert = false,
      this.radius = 12,
      this.minWidth = 48,
      this.height = 48,
      this.safeArea = false,
      this.shadow = true,
      this.padding})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var buttonColor = (widget.backgroundColor != null
        ? widget.backgroundColor!
        : (widget.invert
            ? Colors.white
            : (widget.secondary ? Color(0xFFBEBEBE) : Get.theme.primaryColor)));

    var textColor = (widget.invert
            ? (widget.icon != null
                ? Get.theme.primaryColor
                : Get.theme.textTheme.bodyText1?.color ?? Colors.black)
            : Colors.white)
        .withOpacity((widget.disabled || widget.loading) ? .75 : 1);
    if (widget.secondary) textColor = Get.theme.textTheme.bodyText1!.color!;
    if (buttonColor != Colors.transparent) {
      buttonColor.withOpacity((widget.loading) ? .75 : 1);
      if (widget.disabled) buttonColor = Color(0xFFaaaaaa);
    }

    EdgeInsets padding = widget.padding ??
        EdgeInsets.symmetric(horizontal: widget.icon != null ? 0 : 16);
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: widget.shadow && buttonColor != Colors.transparent
              ? [Themes.buttonShadow(buttonColor)]
              : null),
      child: Material(
        borderRadius: BorderRadius.circular(widget.radius),
        clipBehavior: Clip.antiAlias,
        color: buttonColor,
        child: InkWell(
          onTap: () {
            widget.onPressed();
          },
          child: SafeArea(
            top: false,
            bottom: widget.safeArea,
            left: widget.safeArea,
            right: widget.safeArea,
            child: Padding(
              padding: padding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  //minHeight: 48,
                  minWidth: widget.minWidth,
                  //maxHeight: 48,
                ),
                child: DefaultTextStyle(
                    style: Get.theme.textTheme.bodyText1!
                        .apply(color: textColor, fontWeightDelta: 1),
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
                        child: (widget.icon != null
                                ? IconTheme(
                                    data: IconThemeData(
                                        color: widget.secondary
                                            ? Get.theme.textTheme.bodyText1
                                                ?.color
                                            : Get.theme.primaryColor),
                                    child: widget.icon!)
                                : widget.child) ??
                            SizedBox(),
                      )
                    ])),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
