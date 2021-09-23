import 'package:flutter/material.dart';
import 'package:hikee/old_providers/pagination_change_notifier.dart';
import 'package:provider/provider.dart';

class InfiniteScroll<T extends PaginationChangeNotifier, U>
    extends StatefulWidget {
  const InfiniteScroll(
      {Key? key,
      this.shrinkWrap = false,
      required this.builder,
      required this.selector,
      required this.fetch,
      this.padding = const EdgeInsets.all(16),
      this.take,
      this.overflowBuilder,
      this.separator,
      this.horizontal = false,
      this.empty,
      this.initial,
      this.init = true})
      : super(key: key);

  final bool shrinkWrap;
  final Widget Function(U item) builder;
  final List<U> Function(T provider) selector;
  final void Function(bool next) fetch;
  final EdgeInsets padding;
  final int? take;

  /// When number of items is greater than take, the last showing item will be built with [overflowBuilder]
  final Widget Function(U item, int displayCount, int totalCount)?
      overflowBuilder;

  /// Widget used to separate items
  final Widget? separator;

  /// Indicates whether the list should be horizontal
  final bool horizontal;

  /// Widget to be shown when the list is empty
  /// String will be converted into Text widget
  final dynamic empty;

  /// Widget to be shown when the search is not initiated
  /// String will be converted into Text widget
  final dynamic initial;
  final bool init;

  @override
  _InfiniteScrollState<T, U> createState() => _InfiniteScrollState<T, U>();
}

class _InfiniteScrollState<T extends PaginationChangeNotifier, U>
    extends State<InfiniteScroll<T, U>> {
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
      if (widget.take != null) {
        itemCount = itemCount.clamp(0, widget.take!);
      }
      if (p.fetchCount == 0) {
        if (widget.initial is Widget) return widget.initial;
        if (widget.initial is Text) return Center(child: Text(widget.initial));
        return Container();
      }
      if (itemCount == 0) {
        if (p.loading) return Center(child: CircularProgressIndicator());
        if (widget.empty is Widget) return widget.empty;
        return Center(child: Text(widget.empty ?? 'Nothing here'));
      }
      return widget.separator != null
          ? ListView.separated(
              scrollDirection:
                  widget.horizontal ? Axis.horizontal : Axis.vertical,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              controller: _scrollController,
              itemCount: itemCount,
              separatorBuilder: (_, __) => widget.separator!,
              itemBuilder: (_, i) {
                if (widget.take != null &&
                    i == widget.take! - 1 &&
                    widget.overflowBuilder != null) {
                  return widget.overflowBuilder!(
                      widget.selector(p)[i], itemCount, p.totalCount);
                }
                return widget.builder(widget.selector(p)[i]);
              })
          : ListView.builder(
              scrollDirection:
                  widget.horizontal ? Axis.horizontal : Axis.vertical,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              controller: _scrollController,
              itemCount: itemCount,
              itemBuilder: (_, i) {
                if (widget.take != null &&
                    i == widget.take! - 1 &&
                    widget.overflowBuilder != null) {
                  return widget.overflowBuilder!(
                      widget.selector(p)[i], itemCount, p.totalCount);
                }
                return widget.builder(widget.selector(p)[i]);
              });
    });
  }
}
