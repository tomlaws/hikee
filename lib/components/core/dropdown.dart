import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:collection/collection.dart';

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
      this.formFieldState})
      : super(key: key);

  @override
  _DropdownState<T> createState() => _DropdownState<T>();
  final String? label;
  final Widget Function(T) itemBuilder;
  final List<T> items;
  final FormFieldState<T>? formFieldState;
}

class _DropdownState<T> extends State<Dropdown<T>> {
  @override
  void initState() {
    super.initState();
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
                child: widget.formFieldState?.value != null
                    ? widget.itemBuilder(widget.formFieldState!.value!)
                    : Text("select...".tr,
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFC5C5C5))),
              ),
            ),
          ),
        ]));
  }
}

class MultiDropdownField<T> extends FormField<List<T>> {
  MultiDropdownField({
    Key? key,
    String? label,
    required Widget Function(T item, bool selected) itemBuilder,
    required List<T> items,
    List<T>? selected,
    FormFieldSetter<List<T>>? onSaved,
    FormFieldValidator<List<T>>? validator,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: selected,
            builder: (FormFieldState<List<T>> state) {
              return MultiDropdown<T>(
                label: label,
                items: items,
                itemBuilder: itemBuilder,
                formFieldState: state,
              );
            });
}

class MultiDropdown<T> extends StatefulWidget {
  const MultiDropdown(
      {Key? key,
      this.label,
      required this.items,
      required this.itemBuilder,
      this.formFieldState})
      : super(key: key);

  @override
  _MultiDropdownState<T> createState() => _MultiDropdownState<T>();
  final String? label;
  final Widget Function(T item, bool selected) itemBuilder;
  final List<T> items;
  final FormFieldState<List<T>>? formFieldState;
}

class _MultiDropdownState<T> extends State<MultiDropdown<T>> {
  @override
  void initState() {
    super.initState();
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
          DialogUtils.showSimpleDialog(widget.label ?? 'select...'.tr,
              StatefulBuilder(builder: (context, setState) {
            return Column(
              children: widget.items
                  .map((e) => Material(
                        color: Colors.transparent,
                        child: InkWell(
                          radius: 16,
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            if (widget.formFieldState?.value != null) {
                              if (widget.formFieldState!.value!.contains(e)) {
                                widget.formFieldState!.value!.remove(e);
                                widget.formFieldState!
                                    .didChange(widget.formFieldState!.value);
                              } else {
                                widget.formFieldState!.value?.add(e);
                                widget.formFieldState!
                                    .didChange(widget.formFieldState!.value);
                              }
                              print(widget.formFieldState?.value!.length);
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            child: Center(
                                child: widget.itemBuilder(
                                    e,
                                    widget.formFieldState?.value?.contains(e) ??
                                        false)),
                          ),
                        ),
                      ))
                  .toList(),
            );
          }));
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
                child: widget.formFieldState?.value != null &&
                        widget.formFieldState!.value!.length > 0
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (_, i) => Container(
                              height: 44,
                              child: Center(
                                child: widget.itemBuilder(
                                    widget.formFieldState!.value!.elementAt(i),
                                    false),
                              ),
                            ),
                        separatorBuilder: (_, __) =>
                            Container(child: Center(child: Text(', '))),
                        itemCount: widget.formFieldState!.value!.length)
                    : Text("select...".tr,
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFC5C5C5))),
              ),
            ),
          ),
        ]));
  }
}
