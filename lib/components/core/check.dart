import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Check extends StatefulWidget {
  final String label;
  final bool checked;
  final Function(bool checked) onTap;
  const Check(
      {Key? key,
      required this.label,
      required this.checked,
      required this.onTap})
      : super(key: key);

  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  @override
  Widget build(BuildContext context) {
    double size = widget.checked ? 10 : 0;
    return GestureDetector(
      onTap: () {
        widget.onTap(!widget.checked);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: Color(0xFFe2e2e2),
                borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 200),
                width: size,
                height: size,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.circular(16)),
                child: SizedBox(),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(widget.label)
        ],
      ),
    );
  }
}
