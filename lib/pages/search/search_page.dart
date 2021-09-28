import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/pages/search/search_controller.dart';

class SearchPage<T extends PaginationController<Paginated<U>>, U>
    extends StatelessWidget {
  late SearchController _searchController;
  late T _controller;

  final Widget Function(U item) builder;
  final T Function() controllerBuilder;
  SearchPage({Key? key, required this.builder, required this.controllerBuilder})
      : super(key: key) {
    Get.lazyPut(() => SearchController(), tag: 'search-$key');
    Get.lazyPut(controllerBuilder, tag: 'search-$key-source');

    _searchController = Get.find<SearchController>(tag: 'search-$key');
    _controller = Get.find<T>(tag: 'search-$key-source');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: HikeeAppBar(
          elevation: 2,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextInput(
                  textEditingController: _searchController.searchController,
                  hintText: 'Search...',
                  textInputAction: TextInputAction.search,
                  icon: Icon(Icons.search),
                  autoFocus: true,
                  onSubmitted: (q) {
                    _controller.query = q;
                    _searchController.searched.value = true;
                  },
                ),
              ),
            ],
          ),
        ),
        body: Obx(() => _searchController.searched.value
            ? InfiniteScroller<U>(
                controller: _controller,
                firstFetch: false,
                separator: SizedBox(
                  height: 8,
                ),
                builder: (item) {
                  return builder(item);
                },
              )
            : SizedBox()));
  }
}
