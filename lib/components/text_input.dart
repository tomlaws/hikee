import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextInput extends StatefulWidget {
  final String? hintText;
  final TextEditingController? textEditingController;
  final TextInputController? controller;
  final bool obscureText;
  const TextInput(
      {Key? key,
      this.hintText,
      this.textEditingController,
      this.controller,
      this.obscureText = false})
      : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;
  late Animation _colorTween2;
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorTween = ColorTween(begin: Color(0xFFF6F6F6), end: Color(0xFFECECEC))
        .animate(_animationController);
    _colorTween2 = ColorTween(begin: Color(0xFFECECEC), end: Color(0xFFE2E2E2))
        .animate(_animationController);
    _focus.addListener(_onFocusChange);
    super.initState();
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
              Container(
                decoration: BoxDecoration(
                    color: _colorTween.value,
                    border: Border.all(color: _colorTween2.value),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: TextField(
                    focusNode: _focus,
                    controller:
                        widget.controller ?? widget.textEditingController,
                    autofocus: false,
                    obscureText: widget.obscureText,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xFFC5C5C5)),
                        hintText: widget.hintText)),
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
                            padding: EdgeInsets.symmetric(horizontal: 16),
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
