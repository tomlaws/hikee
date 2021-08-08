import 'package:flutter/material.dart';
import 'package:hikee/models/error/error_response.dart';

class MutationBuilder<T> extends StatefulWidget {
  const MutationBuilder(
      {Key? key,
      required this.mutation,
      this.onDone,
      this.onError,
      required this.builder})
      : super(key: key);
  final Future<T?> Function() mutation;
  final void Function(T?)? onDone;
  final void Function(ErrorResponse)? onError;
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
        if (widget.onError != null && ex is ErrorResponse) widget.onError!(ex);
      }
      setState(() {
        _loading = false;
      });
    }, _loading);
  }
}
