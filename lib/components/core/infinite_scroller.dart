import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/connection_error.dart';
import 'package:hikees/controllers/shared/pagination.dart';

class InfiniteScroller<U> extends StatefulWidget {
  const InfiniteScroller(
      {Key? key,
      this.headers,
      this.footersBuilder,
      required this.builder,
      this.controller,
      this.controllerBuilder,
      this.scrollController,
      this.padding = const EdgeInsets.all(16),
      this.firstFetch = true,
      this.take,
      this.overflowBuilder,
      this.separator,
      this.horizontal = false,
      this.empty,
      this.initial,
      this.loadingBuilder,
      this.loadingItemCount = 5,
      this.refreshable = true,
      this.edgeOffset = 0.0,
      this.sliversBuilder})
      : super(key: key);

  final List<Widget>? headers;
  final List<Widget> Function(bool hasMore)? footersBuilder;
  final Widget Function(U item) builder;
  final PaginationController<U>? controller;
  final PaginationController<U> Function()? controllerBuilder;
  final ScrollController? scrollController;
  final EdgeInsets padding;
  final int? take;

  /// When number of items is greater than take, the last showing item will be built with [overflowBuilder]
  final Widget Function(U? item, int displayCount, int totalCount)?
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

  /// Widget to show when it is loading
  final Widget? loadingBuilder;

  /// Number of fake items (Built from [loadingBuilder]) to be shown when it is in loading state
  final int loadingItemCount;

  final bool refreshable;

  final double edgeOffset;

  final List<Widget> Function(Widget list)? sliversBuilder;

  @override
  _InfiniteScrollerState<U> createState() => _InfiniteScrollerState<U>();
}

class _InfiniteScrollerState<U> extends State<InfiniteScroller<U>> {
  late ScrollController _scrollController;
  late PaginationController<U> controller;

  @override
  void initState() {
    super.initState();
    if (widget.controllerBuilder != null) {
      Get.lazyPut(widget.controllerBuilder!);
    }
    controller = widget.controller ?? Get.find<PaginationController<U>>();
    if (widget.firstFetch) controller.next();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(() {
      if (widget.take != null) {
        var len = controller.state?.data.length;
        if (len != null && len >= widget.take!) return;
      }
      double diff = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (diff < 500) {
        controller.next();
      }
    });
  }

  @override
  void dispose() {
    if (widget.scrollController == null) _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller.obx((state) {
      var data = state;
      var items = data?.data ?? [];
      var itemCount = items.length;
      if (widget.take != null) {
        itemCount = itemCount.clamp(0, widget.take!);
      }
      return _list(itemCount, (_, i) {
        if (widget.take != null &&
            i == widget.take! - 1 &&
            widget.overflowBuilder != null) {
          return widget.overflowBuilder!(
              items[i], itemCount - 1, data?.totalCount ?? 0);
        }
        return widget.builder(items[i]);
      });
    },
        onLoading: Center(
          child: widget.loadingBuilder != null
              ? _list(
                  min(widget.loadingItemCount,
                      widget.take ?? widget.loadingItemCount), (_, i) {
                  if (widget.take != null &&
                      i == widget.take! - 1 &&
                      widget.overflowBuilder != null) {
                    return widget.overflowBuilder!(
                        null, widget.take! - 1, widget.loadingItemCount);
                  }
                  return widget.loadingBuilder!;
                })
              : CircularProgressIndicator(),
        ),
        onError: (error) => ConnectionError(),
        onEmpty: SizedBox());
  }

  Widget _list(int itemCount, Widget Function(BuildContext, int) itemBuilder) {
    Widget list = SliverPadding(
        padding: widget.padding,
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate((c, i) {
          if (widget.separator != null) {
            if (i.isOdd) return widget.separator;
            return itemBuilder(c, i ~/ 2);
          } else {
            return itemBuilder(c, i);
          }
        },
                childCount:
                    widget.separator != null ? itemCount * 2 - 1 : itemCount)));

    Widget footer = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (itemCount == 0 && widget.empty != null)
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: widget.horizontal ? null : double.infinity,
              child: widget.empty is String
                  ? Center(
                      child: Text(
                      widget.empty,
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ))
                  : widget.empty,
            ),
          ),
        if (widget.footersBuilder != null)
          ...widget.footersBuilder!(
              controller.hasMore || itemCount < controller.totalCount)
      ],
    );
    if (widget.take == null || widget.horizontal) {
      footer = SliverFillRemaining(hasScrollBody: false, child: footer);
    } else {
      footer = SliverToBoxAdapter(
        child: footer,
      );
    }

    Widget ret = CustomScrollView(
        scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
        shrinkWrap: widget.take != null,
        controller: _scrollController,
        physics: widget.take == null
            ? const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics())
            : null,
        slivers: [
          if (widget.headers != null)
            SliverToBoxAdapter(
              child: Column(children: widget.headers!),
            ),
          if (widget.sliversBuilder == null)
            list
          else
            ...widget.sliversBuilder!(list),
          footer
        ]);
    if (widget.refreshable && widget.take == null) {
      ret = RefreshIndicator(
        child: ret,
        onRefresh: controller.refetch,
        displacement: 80.0,
        edgeOffset: widget.edgeOffset,
      );
    }
    return ret;
  }
}
