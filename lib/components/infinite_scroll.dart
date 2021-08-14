import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfiniteScroll<T, U> extends StatefulWidget {
  const InfiniteScroll(
      {Key? key,
      this.shrinkWrap = false,
      required this.builder,
      required this.selector,
      required this.fetch,
      this.padding = const EdgeInsets.all(16),
      })
      : super(key: key);

  final bool shrinkWrap;
  final Widget Function(U item) builder;
  final List<U> Function(T provider) selector;
  final void Function(bool next) fetch;
  final EdgeInsets padding;

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
    return Consumer<T>(
      builder: (_, p, __) => ListView.builder(
          shrinkWrap: widget.shrinkWrap,
          padding: widget.padding,
          controller: _scrollController,
          itemCount: widget.selector(p).length,
          itemBuilder: (_, i) {
            return widget.builder(widget.selector(p)[i]);
          }),
    );
  }
}
