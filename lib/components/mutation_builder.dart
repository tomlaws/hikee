import 'package:flutter/material.dart';

class MutationBuilder<T> extends StatefulWidget {
  const MutationBuilder(
      {Key? key, required this.mutation, this.onDone, required this.builder})
      : super(key: key);
  final Future<T?> Function() mutation;
  final void Function(T?)? onDone;
  final Widget Function(void Function() mutate, bool) builder;
  @override
  _MutationBuilderState<T> createState() => _MutationBuilderState<T>();
}

class _MutationBuilderState<T> extends State<MutationBuilder<T>> {
  bool _loading = false;
  T? result;

  @override
  Widget build(BuildContext context) {
    return widget.builder(() async {
      setState(() {
        _loading = true;
      });
      try {
        result = await widget.mutation();
        if (widget.onDone != null) {
          widget.onDone!(result);
        }
      } catch (ex) {
        print(ex);
      }
      setState(() {
        _loading = false;
      });
    }, _loading);
  }
}
