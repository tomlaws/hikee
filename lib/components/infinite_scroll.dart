import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfiniteScroll<T, U> extends StatefulWidget {
  const InfiniteScroll(
      {Key? key,
      this.shrinkWrap = false,
      required this.builder,
      required this.selector,
      required this.loading,
      required this.fetch,
      this.padding = const EdgeInsets.all(16),
      this.take,
      this.separator,
      this.empty,
      this.init = true})
      : super(key: key);

  final bool shrinkWrap;
  final Widget Function(U item) builder;
  final List<U> Function(T provider) selector;
  final bool Function(T provider) loading;
  final void Function(bool next) fetch;
  final EdgeInsets padding;
  final int? take;
  final Widget? separator;

  /// Widget to be shown when the list is empty
  /// String will be converted into Text widget
  final dynamic empty;
  final bool init;

  @override
  _InfiniteScrollState<T, U> createState() => _InfiniteScrollState<T, U>();
}

class _InfiniteScrollState<T, U> extends State<InfiniteScroll<T, U>> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.init)
      Future.microtask(() {
        widget.fetch(false);
      });
    _scrollController.addListener(() {
      if (widget.take != null) {
        var len = widget.selector(context.read<T>()).length;
        if (len >= widget.take!) return;
      }
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
    return Consumer<T>(builder: (_, p, __) {
      var itemCount = widget.selector(p).length;
      if (widget.take != null) itemCount = itemCount.clamp(0, widget.take!);
      if (itemCount == 0) {
        if (widget.loading(p)) {
          return Center(child: CircularProgressIndicator());
        }
        if (widget.empty is Widget) return widget.empty;
        return Center(child: Text(widget.empty ?? 'Nothing here'));
      }
      return widget.separator != null
          ? ListView.separated(
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              controller: _scrollController,
              itemCount: itemCount,
              separatorBuilder: (_, __) => widget.separator!,
              itemBuilder: (_, i) {
                return widget.builder(widget.selector(p)[i]);
              })
          : ListView.builder(
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              controller: _scrollController,
              itemCount: itemCount,
              itemBuilder: (_, i) {
                return widget.builder(widget.selector(p)[i]);
              });
    });
  }
}
