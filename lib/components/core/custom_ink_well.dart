import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// An [InkWell] equivalent for Cupertino. Simply colors the background of the container.
class CustomInkWell extends StatefulWidget {
  const CustomInkWell({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;

  bool get enabled => onTap != null;

  @override
  State<CustomInkWell> createState() => _CustomInkWellState();
}

class _CustomInkWellState extends State<CustomInkWell> {
  bool _tapped = false;

  void _handleTapDown(TapDownDetails event) {
    print('down');
    if (!_tapped) {
      setState(() {
        _tapped = true;
      });
    }
  }

  Future<void> _handleTapUp(TapUpDetails event) async {
    print('up');
    if (_tapped) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted)
        setState(() {
          _tapped = false;
        });
    }
  }

  void _handleTapCancel() {
    if (_tapped) {
      setState(() {
        _tapped = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onTap,
      child: AnimatedContainer(
        color: _tapped ? Colors.grey.shade200 : Colors.white,
        duration: const Duration(milliseconds: 50),
        child: widget.child,
      ),
    );
  }
}
