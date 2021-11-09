import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/pages/search/search_controller.dart';

class SearchPage<U> extends StatefulWidget {
  const SearchPage(
      {Key? key,
      required this.tag,
      required this.builder,
      required this.controller})
      : super(key: key);

  @override
  _SearchPageState<U> createState() => _SearchPageState<U>();

  final String tag;
  final Widget Function(U item) builder;
  final PaginationController<Paginated<U>> controller;
}

class _SearchPageState<U> extends State<SearchPage<U>> {
  late SearchController<U> _searchController;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SearchController<U>(), tag: widget.tag);
    _searchController = Get.find<SearchController<U>>(tag: widget.tag);
    _searchController.loadHistory(widget.tag);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: HikeeAppBar(
          actions: [
            Button(
              onPressed: () {},
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
            hintText: 'Search...',
            textInputAction: TextInputAction.search,
            icon: Icon(Icons.search),
            autoFocus: true,
            onSubmitted: (q) {
              widget.controller.query = q;
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
                      widget.controller.query = _searchController.history[i];
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
                    controller: widget.controller,
                    firstFetch: false,
                    empty: Center(
                      child: Text('No results found'),
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
