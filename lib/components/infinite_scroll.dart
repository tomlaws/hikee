import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfiniteScroll<T, U> extends StatefulWidget {
  const InfiniteScroll(
      {Key? key,
      required this.builder,
      required this.selector,
      required this.fetch})
      : super(key: key);

  final Widget Function(U item) builder;
  final List<U> Function(T provider) selector;
  final void Function(bool next) fetch;

  @override
  _InfiniteScrollState<T, U> createState() => _InfiniteScrollState<T, U>();
}

class _InfiniteScrollState<T, U> extends State<InfiniteScroll<T, U>> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      widget.fetch(false);
    });
    _scrollController.addListener(() {
      double diff = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (diff < 500) {
        widget.fetch(true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<U> items = widget.selector(context.watch<T>());
    return ListView.builder(
        padding: EdgeInsets.all(16),
        controller: _scrollController,
        itemCount: items.length,
        itemBuilder: (_, i) {
          return widget.builder(items[i]);
        });
  }
}
