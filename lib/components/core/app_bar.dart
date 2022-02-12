import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';

class HikeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HikeeAppBar(
      {Key? key,
      this.title,
      this.titlePadding = true,
      this.pinned = false,
      this.leading,
      this.canPop,
      this.actions,
      this.elevation = 2,
      this.height = 60,
      this.closeIcon})
      : super(key: key);

  final Widget? title;
  final bool titlePadding;
  final bool pinned;
  final Widget? leading;
  final bool? canPop;
  final List<Widget>? actions;
  final double? elevation;
  final double height;
  final IconData? closeIcon;

  @override
  Widget build(BuildContext context) {
    var backButton = canPop != null ? canPop! : ModalRoute.of(context)!.canPop;
    return AppBar(
      iconTheme: IconThemeData(color: Colors.green, size: 24),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     bottom: Radius.circular(12),
      //   ),
      // ),
      elevation: elevation,
      titleTextStyle: TextStyle(fontSize: 12),
      title: title == null
          ? null
          : DefaultTextStyle(
              style: TextStyle(
                  color: Get.theme.textTheme.bodyText1?.color ?? Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              child: Padding(
                padding: EdgeInsets.only(
                    left:
                        leading != null || backButton || !titlePadding ? 0 : 8,
                    right: 8.0),
                child: title,
              ),
            ),
      leadingWidth: 44 + 8 * 2,
      leading: leading != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: leading,
            )
          : (backButton
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Button(
                    backgroundColor: Colors.transparent,
                    icon: Icon(closeIcon ?? Icons.chevron_left,
                        color: Get.theme.textTheme.bodyText1?.color ??
                            Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              : null),
      automaticallyImplyLeading: false,
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!
                      .map((e) => SizedBox(
                            height: 44,
                            width: 44,
                            child: e,
                          ))
                      .toList(),
                ),
              )
            ]
          : null,
      backgroundColor: Colors.white,
      shadowColor: Colors.black26,
      toolbarHeight: height,
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
