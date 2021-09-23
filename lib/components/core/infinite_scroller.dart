import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InfiniteScroller<U> extends StatefulWidget {
  const InfiniteScroller({
    Key? key,
    this.shrinkWrap = false,
    required this.builder,
    required this.controller,
    this.padding = const EdgeInsets.all(16),
    this.firstFetch = true,
    this.take,
    this.overflowBuilder,
    this.separator,
    this.horizontal = false,
    this.empty,
    this.initial,
  }) : super(key: key);

  final bool shrinkWrap;
  final Widget Function(U item) builder;
  final PaginationController<Paginated<U>> controller;
  final EdgeInsets padding;
  final int? take;

  /// When number of items is greater than take, the last showing item will be built with [overflowBuilder]
  final Widget Function(U item, int displayCount, int totalCount)?
      overflowBuilder;

  /// Whether to fetch for the first time
  final bool firstFetch;

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

  @override
  _InfiniteScrollerState<U> createState() => _InfiniteScrollerState<U>();
}

class _InfiniteScrollerState<U> extends State<InfiniteScroller<U>> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.firstFetch) widget.controller.next();
    _scrollController.addListener(() {
      if (widget.take != null) {
        var len = widget.controller.state?.data.length;
        if (len != null && len >= widget.take!) return;
      }
      double diff = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (diff < 500) {
        widget.controller.next();
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
    return widget.controller.obx((state) {
      var data = state;
      var items = data?.data ?? [];
      var itemCount = items.length;
      if (widget.take != null) {
        itemCount = itemCount.clamp(0, widget.take!);
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
                // if (widget.take != null &&
                //     i == widget.take! - 1 &&
                //     widget.overflowBuilder != null) {
                //   return widget.overflowBuilder!(
                //       widget.selector(p)[i], itemCount, p.totalCount);
                // }
                return widget.builder(items[i]);
              })
          : ListView.builder(
              scrollDirection:
                  widget.horizontal ? Axis.horizontal : Axis.vertical,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              controller: _scrollController,
              itemCount: itemCount,
              itemBuilder: (_, i) {
                // if (widget.take != null &&
                //     i == widget.take! - 1 &&
                //     widget.overflowBuilder != null) {
                //   return widget.overflowBuilder!(
                //       widget.selector(p)[i], itemCount, p.totalCount);
                // }
                return widget.builder(items[i]);
              });
    },
        onLoading: Center(
          child: CircularProgressIndicator(),
        ),
        onEmpty: SizedBox());
  }
}
