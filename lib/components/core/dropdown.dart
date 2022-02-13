import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/utils/dialog.dart';

class Dropdown<T> extends StatefulWidget {
  const Dropdown(
      {Key? key,
      this.label,
      required this.items,
      required this.itemBuilder,
      required this.selected,
      required this.onChanged})
      : super(key: key);

  @override
  _DropdownState<T> createState() => _DropdownState<T>();
  final String? label;
  final Widget Function(T) itemBuilder;
  final List<T> items;
  final T? selected;
  final Function(T) onChanged;
}

class _DropdownState<T> extends State<Dropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          DialogUtils.showDialog(
              "Regions",
              Column(
                children: widget.items
                    .map((e) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            radius: 16,
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              widget.onChanged(e);
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              width: double.infinity,
                              child: Center(child: widget.itemBuilder(e)),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              showDismiss: false);
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, left: 8),
              child: Text(widget.label!,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            height: 42,
            decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Align(
              alignment: Alignment.centerLeft,
              child: widget.selected != null
                  ? widget.itemBuilder(widget.selected!)
                  : Text("Select...",
                      style: TextStyle(color: Color(0xFFC5C5C5))),
            ),
          ),
        ]));
  }
}
