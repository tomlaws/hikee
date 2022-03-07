import 'package:flutter/material.dart';
import 'package:hikees/themes.dart';

class FloatingTooltip extends StatefulWidget {
  const FloatingTooltip(
      {Key? key,
      required this.child,
      this.ignorePointer = true,
      this.animation = false,
      this.compact = false,
      this.color = const Color(0xFFFFFFFF)})
      : super(key: key);

  final Widget child;
  final bool ignorePointer;
  final bool animation;
  final bool compact;
  final Color color;

  @override
  _FloatingTooltipState createState() => _FloatingTooltipState();
}

class _FloatingTooltipState extends State<FloatingTooltip>
    with SingleTickerProviderStateMixin {
  AnimationController? tooltipController;
  Animation<int>? alpha;

  @override
  void initState() {
    super.initState();
    if (widget.animation) {
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    alpha = null;
    tooltipController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FloatingTooltip oldWidget) {
    if (oldWidget.animation == false && widget.animation) {
      _setupAnimation();
    }
    if (oldWidget.animation && widget.animation == false) {
      alpha = null;
      tooltipController?.dispose();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setupAnimation() {
    tooltipController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    Animation<double> curve = CurvedAnimation(
        parent: tooltipController!, curve: Curves.easeInOutSine);
    alpha = IntTween(begin: 0, end: 10).animate(curve);
    tooltipController?.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final tooltip = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(widget.compact ? 4.0 : 16),
          decoration: BoxDecoration(
              boxShadow: [Themes.shadow],
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.compact ? 4.0 : 16.0)),
          child: widget.child,
        ),
        Positioned.fill(
          bottom: (widget.compact ? -6 : -10) + 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                color: widget.color,
                height: widget.compact ? 6 : 10,
                width: widget.compact ? 12 : 20,
              ),
            ),
          ),
        ),
      ],
    );
    return tooltipController != null
        ? IgnorePointer(
            ignoring: widget.ignorePointer,
            child: AnimatedBuilder(
              animation: tooltipController!,
              builder: (_, __) => Padding(
                  padding: EdgeInsets.only(bottom: alpha!.value.toDouble()),
                  child: tooltip),
            ),
          )
        : IgnorePointer(
            ignoring: widget.ignorePointer,
            child: tooltip,
          );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
