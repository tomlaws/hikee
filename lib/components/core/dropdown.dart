import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/utils/dialog.dart';

class DropdownField<T> extends FormField<T> {
  DropdownField({
    Key? key,
    String? label,
    required Widget Function(T) itemBuilder,
    required List<T> items,
    T? selected,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: selected,
            builder: (FormFieldState<T> state) {
              return Dropdown<T>(
                label: label,
                items: items,
                itemBuilder: itemBuilder,
                selected: selected,
                formFieldState: state,
              );
            });
}

class Dropdown<T> extends StatefulWidget {
  const Dropdown(
      {Key? key,
      this.label,
      required this.items,
      required this.itemBuilder,
      required this.selected,
      this.formFieldState})
      : super(key: key);

  @override
  _DropdownState<T> createState() => _DropdownState<T>();
  final String? label;
  final Widget Function(T) itemBuilder;
  final List<T> items;
  final T? selected;
  final FormFieldState<T>? formFieldState;
}

class _DropdownState<T> extends State<Dropdown<T>> {
  var _selected = Rxn<T>();
  @override
  void initState() {
    super.initState();
    _selected.value = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final InputDecoration? effectiveDecoration = widget.formFieldState != null
        ? InputDecoration.collapsed(hintText: 'select...'.tr).applyDefaults(
            Theme.of(widget.formFieldState!.context).inputDecorationTheme,
          )
        : null;
    return GestureDetector(
        onTap: () {
          DialogUtils.showSimpleDialog(
              widget.label ?? 'select...'.tr,
              Column(
                children: widget.items
                    .map((e) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            radius: 16,
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              if (widget.formFieldState != null) {
                                widget.formFieldState!.didChange(e);
                              }
                              _selected.value = e;
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
          InputDecorator(
            decoration: effectiveDecoration != null
                ? effectiveDecoration.copyWith(
                    errorText: widget.formFieldState!.errorText,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF2F2F2),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    isDense: true)
                : const InputDecoration(),
            child: Container(
              height: 44,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                    () => _selected.value != null
                        ? widget.itemBuilder(_selected.value!)
                        : Text("select...".tr,
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFC5C5C5))),
                  )),
            ),
          ),
        ]));
  }
}
