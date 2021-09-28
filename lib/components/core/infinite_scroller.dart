import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';

class InfiniteScroller<U> extends StatefulWidget {
  const InfiniteScroller({
    Key? key,
    this.shrinkWrap = false,
    required this.builder,
    this.controller,
    this.controllerBuilder,
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
  final PaginationController<Paginated<U>>? controller;
  final PaginationController<Paginated<U>> Function()? controllerBuilder;
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
  late PaginationController<Paginated<U>> controller;

  @override
  void initState() {
    super.initState();
    if (widget.controllerBuilder != null) {
      Get.lazyPut(widget.controllerBuilder!);
    }
    controller =
        widget.controller ?? Get.find<PaginationController<Paginated<U>>>();
    if (widget.firstFetch) controller.next();
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
    _scrollController.dispose();
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
      if (itemCount == 0 && widget.empty != null) {
        if (widget.empty is String) {
          return Text(widget.empty);
        }
        return widget.empty;
      }
      return widget.separator != null
          ? ListView.separated(
              clipBehavior: Clip.none,
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
                      items[i], itemCount - 1, data?.totalCount ?? 0);
                }
                return widget.builder(items[i]);
              })
          : ListView.builder(
              clipBehavior: Clip.none,
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
                      items[i], itemCount, data?.totalCount ?? 0);
                }
                return widget.builder(items[i]);
              });
    },
        onLoading: Center(
          child: CircularProgressIndicator(),
        ),
        onEmpty: SizedBox());
  }
}
