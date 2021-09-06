import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextInput extends StatefulWidget {
  final String? hintText;
  final TextEditingController? textEditingController;
  final TextInputController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final Icon? icon;
  final bool expand;
  final double radius;
  final bool transparent;
  final String? label;
  final Function? onTap;
  final bool autoFocus;

  const TextInput(
      {Key? key,
      this.hintText,
      this.textEditingController,
      this.controller,
      this.maxLines = 1,
      this.keyboardType,
      this.obscureText = false,
      this.textInputAction,
      this.onSubmitted,
      this.icon,
      this.expand = false,
      this.radius = 12,
      this.transparent = false,
      this.label,
      this.onTap,
      this.autoFocus = false})
      : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorTween = ColorTween(begin: Color(0xFFF2F2F2), end: Color(0xFFECECEC))
        .animate(_animationController);
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      _animationController.forward();
      if (widget.onTap != null) {
        widget.onTap!();
        _focus.unfocus();
      }
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) =>
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (widget.label != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(widget.label!),
                ),
              Expanded(
                flex: widget.expand ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.transparent ? null : _colorTween.value,
                      //border: widget.transparent ? null : Border.all(color: _colorTween2.value),
                      borderRadius:
                          BorderRadius.all(Radius.circular(widget.radius))),
                  child: TextField(
                      focusNode: _focus,
                      controller:
                          widget.controller ?? widget.textEditingController,
                      textInputAction: widget.textInputAction,
                      onSubmitted: widget.onSubmitted,
                      autofocus: widget.autoFocus,
                      obscureText: widget.obscureText,
                      maxLines: widget.maxLines,
                      keyboardType: widget.keyboardType,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          prefixIcon: widget.icon == null
                              ? null
                              : IconTheme(
                                  data: IconThemeData(
                                      color: Colors.grey, size: 18),
                                  child: SizedBox(
                                      child: widget.icon,
                                      width: 24,
                                      height: 24)),
                          prefixIconConstraints:
                              BoxConstraints(maxHeight: 24, minWidth: 32),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          filled: false,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xFFC5C5C5)),
                          hintText: widget.hintText)),
                ),
              ),
              if (widget.controller != null)
                ValueListenableBuilder(
                    valueListenable: widget.controller!.errorListenable,
                    builder: (_, error, __) {
                      if (error == null) return SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 4),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Text(widget.controller!.error!,
                                style: TextStyle(color: Colors.red)),
                          )
                        ],
                      );
                    })
            ]));
  }
}

class TextInputController extends TextEditingController {
  TextInputController({String? text}) : super(text: text);
  ValueNotifier<String?> _error = ValueNotifier(null);
  set error(String? value) => _error.value = value;
  String? get error => _error.value;
  get errorListenable => _error;

  void clearError() => _error.value = null;
}
