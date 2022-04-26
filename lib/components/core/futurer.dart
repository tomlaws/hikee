import 'package:flutter/material.dart';

class Futurer<T> extends StatelessWidget {
  Futurer(
      {Key? key, this.future, required this.placeholder, required this.builder})
      : super(key: key);
  final Future<T>? future;
  final Widget placeholder;
  final Widget Function(T data) builder;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return builder(snapshot.data!);
          }
          return placeholder;
        });
  }
}
