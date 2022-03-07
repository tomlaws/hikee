import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/pages/search/search_controller.dart';

class SearchPage<U, C extends PaginationController<U>> extends StatefulWidget {
  const SearchPage(
      {Key? key,
      required this.tag,
      required this.controller,
      required this.builder,
      this.filter,
      this.showAll = false})
      : super(key: key);

  @override
  _SearchPageState<U, C> createState() => _SearchPageState<U, C>();

  final String tag;
  final C controller;
  final Widget Function(U item) builder;
  final Widget? filter;
  final bool showAll;
}

class _SearchPageState<U, C extends PaginationController<U>>
    extends State<SearchPage<U, C>> {
  late SearchController<U> _searchController;

  @override
  Widget build(BuildContext context) {
    var _controller = Get.put<C>(widget.controller, tag: widget.tag);
    Get.lazyPut(() => SearchController<U>(), tag: widget.tag);
    _searchController = Get.find<SearchController<U>>(tag: widget.tag);
    _searchController.loadHistory(widget.tag);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: HikeeAppBar(
          actions: [
            if (widget.filter != null)
              Button(
                onPressed: () {
                  Get.to(widget.filter);
                },
                backgroundColor: Colors.transparent,
                secondary: true,
                icon: Icon(
                  Icons.filter_alt_rounded,
                  size: 18,
                ),
              )
          ],
          title: TextInput(
            textEditingController: _searchController.searchController,
            hintText: 'search'.tr + '...',
            textInputAction: TextInputAction.search,
            icon: Icon(Icons.search),
            autoFocus: true,
            onSubmitted: (q) {
              if (q.isEmpty) return;
              _controller.query = q;
              _searchController.addHistory(widget.tag, q);
              _searchController.searched.value = true;
            },
          ),
        ),
        body: Obx(() => _searchController.showHistory.value
            ? ListView.separated(
                itemBuilder: (_, i) {
                  return InkWell(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Opacity(opacity: .5, child: Icon(Icons.history)),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(child: Text(_searchController.history[i]))
                          ],
                        )),
                    onTap: () {
                      _searchController.searchController.text =
                          _searchController.history[i];
                      _controller.query = _searchController.history[i];
                      _searchController.addHistory(
                          widget.tag, _searchController.history[i]);
                      _searchController.searched.value = true;
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
                separatorBuilder: (_, i) => Divider(
                      height: 0,
                    ),
                itemCount: _searchController.history.length)
            : _searchController.searched.value
                ? InfiniteScroller<U>(
                    controller: _controller,
                    firstFetch: false,
                    empty: Center(
                      child: Text('noResultsFound'.tr),
                    ),
                    separator: SizedBox(
                      height: 16,
                    ),
                    builder: (item) {
                      return widget.builder(item);
                    },
                  )
                : SizedBox()));
  }
}
