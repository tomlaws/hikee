import 'package:flutter/material.dart';
import 'package:hikee/models/loading.dart';
import 'package:hikee/models/route.dart';
import 'package:provider/provider.dart';

/// Combines future builder & selector
class FutureSelector<T, U> extends StatefulWidget {
  const FutureSelector({
    Key? key,
    required this.init,
    required this.selector,
    required this.builder,
    this.onNull,
    this.loader,
  }) : super(key: key);
  final Future<U?>? Function(T) init;
  final U? Function(BuildContext, T) selector;
  final Widget Function(BuildContext, U, Widget?) builder;
  final Widget? onNull;
  final Widget? loader;

  @override
  _FutureSelectorState<T, U> createState() => _FutureSelectorState<T, U>();
}

class _FutureSelectorState<T, U> extends State<FutureSelector<T, U>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var future = widget.init(context.read<T>());
    return FutureBuilder<Object?>(
      future: future,
      initialData: Loading(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Selector<T, U>(
            selector: (context, t) => widget.selector(context, t)!,
            builder: widget.builder);
      },
    );
  }
}
