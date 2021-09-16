import 'package:flutter/material.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/riverpods/paginated_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';

class InfiniteScroller<T> extends ConsumerStatefulWidget {
  const InfiniteScroller({
    Key? key,
    required this.provider,
    this.shrinkWrap = false,
    required this.builder,
    this.padding = const EdgeInsets.all(16),
    this.take,
    this.overflowBuilder,
    this.separator,
    this.horizontal = false,
    this.empty,
    this.initial,
  }) : super(key: key);

  final StateNotifierProvider<PaginatedStateNotifier<Paginated<T>?>,
      Paginated<T>?> provider;
  final bool shrinkWrap;
  final Widget Function(T item) builder;
  final EdgeInsets padding;
  final int? take;

  /// When number of items is greater than take, the last showing item will be built with [overflowBuilder]
  final Widget Function(T item, int displayCount, int totalCount)?
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

  @override
  _InfiniteScrollerState<T> createState() => _InfiniteScrollerState<T>();
}

class _InfiniteScrollerState<T> extends ConsumerState<InfiniteScroller<T>> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(widget.provider.notifier).next();
    _scrollController.addListener(() {
      if (widget.take != null) {
        var len = ref.read(widget.provider.notifier).state?.data.length;
        if (len != null && len >= widget.take!) return;
      }
      double diff = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (diff < 500) {
        ref.read(widget.provider.notifier).next();
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
    var data = ref.watch(widget.provider);
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
  }
}
