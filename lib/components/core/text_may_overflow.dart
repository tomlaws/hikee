import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class TextMayOverflow extends StatelessWidget {
  const TextMayOverflow(this.text, {Key? key, this.style}) : super(key: key);
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(text,
        minFontSize: style?.fontSize ?? 12,
        style: style,
        maxLines: 1,
        overflowReplacement: SizedBox(
          height: 22,
          child: Marquee(
            blankSpace: 20.0,
            fadingEdgeStartFraction: .2,
            fadingEdgeEndFraction: .2,
            pauseAfterRound: Duration(seconds: 1),
            velocity: 24.0,
            text: text,
            style: style,
          ),
        ));
  }
}
