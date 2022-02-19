import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/topics/topic_tile.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/pages/search/search_page.dart';
import 'package:hikee/pages/topics/topic_categories.dart';
import 'package:hikee/pages/topics/topic_categories_controller.dart';
import 'package:hikee/pages/topics/topics_controller.dart';

class TopicsPage extends GetView<TopicsController> {
  final categoriesController = Get.put(TopicCategoriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: InfiniteScroller<Topic>(
        refreshable: true,
        controller: controller,
        separator: SizedBox(
          height: 16,
        ),
        builder: (topic) {
          return TopicTile(
            topic: topic,
          );
        },
        loadingBuilder: TopicTile(
          topic: null,
          onTap: () {},
        ),
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
        loadingItemCount: 12,
        sliversBuilder: (list) => [
          SliverAppBar(
            expandedHeight: 60.0,
            collapsedHeight: 60.0,
            pinned: true,
            elevation: 2,
            shadowColor: Colors.black45,
            backgroundColor: Colors.white,
            flexibleSpace: HikeeAppBar(
                elevation: 0,
                actions: [
                  Button(
                    icon: Icon(Icons.add),
                    secondary: true,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Get.toNamed('/topics/create', arguments: {
                        'categoryId': categoriesController.currentCategory.value
                      });
                    },
                  ),
                  Button(
                    icon: Icon(Icons.search),
                    secondary: true,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Get.to(SearchPage<Topic, TopicsController>(
                          tag: 'search-topics',
                          controller: TopicsController(),
                          builder: (topic) => TopicTile(topic: topic)));
                    },
                  )
                ],
                title: TopicCategories()),
          ),
          list
        ],
      ),
    );
  }

  // _showSortMenu() {
  //   DialogUtils.show(
  //       context,
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(bottom: 8),
  //             child: Text('Sort'),
  //           ),
  //           Selector<TopicsProvider, TopicSortable>(
  //             selector: (_, p) => p.sort,
  //             builder: (_, sort, __) => Wrap(
  //                 spacing: 8.0,
  //                 runSpacing: 8.0,
  //                 children: TopicSortable.values
  //                     .map(
  //                       (e) => Button(
  //                         backgroundColor: sort == e ? null : Color(0xFFF5F5F5),
  //                         child: Text(e.name,
  //                             style: sort == e
  //                                 ? null
  //                                 : TextStyle(
  //                                     color: Theme.of(context)
  //                                         .textTheme
  //                                         .bodyText1!
  //                                         .color)),
  //                         onPressed: () {
  //                           context.read<TopicsProvider>().sort = e;
  //                         },
  //                       ),
  //                     )
  //                     .toList()),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.symmetric(vertical: 8),
  //             child: Text('Order'),
  //           ),
  //           Selector<TopicsProvider, Order>(
  //             selector: (_, p) => p.order,
  //             builder: (_, order, __) => Row(
  //               children: [
  //                 Button(
  //                   backgroundColor:
  //                       order == Order.ASC ? null : Color(0xFFF5F5F5),
  //                   child: Text('Ascending',
  //                       style: order == Order.ASC
  //                           ? null
  //                           : TextStyle(
  //                               color: Theme.of(context)
  //                                   .textTheme
  //                                   .bodyText1!
  //                                   .color)),
  //                   onPressed: () {
  //                     //context.read<TopicsProvider>().order = Order.ASC;
  //                   },
  //                 ),
  //                 SizedBox(
  //                   width: 8,
  //                 ),
  //                 Button(
  //                   backgroundColor:
  //                       order == Order.DESC ? null : Color(0xFFF5F5F5),
  //                   child: Text('Descending',
  //                       style: order == Order.DESC
  //                           ? null
  //                           : TextStyle(
  //                               color: Theme.of(context)
  //                                   .textTheme
  //                                   .bodyText1!
  //                                   .color)),
  //                   onPressed: () {
  //                     //context.read<TopicsProvider>().order = Order.DESC;
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ));
  // }
}
