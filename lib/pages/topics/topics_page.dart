import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/topic_tile.dart';
import 'package:hikee/models/order.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/old_providers/auth.dart';
import 'package:hikee/old_providers/topics.dart';
import 'package:hikee/pages/create_topic.dart';
import 'package:hikee/pages/topics/topics_controller.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class TopicsPage extends GetView<TopicsController> {
  final TextEditingController _searchController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton: Button(
      //   onPressed: () {
      //     context.read<AuthProvider>().mustLogin(context, () {
      //       Navigator.of(context, rootNavigator: true)
      //           .push(CupertinoPageRoute(builder: (_) => CreateTopicPage()));
      //     });
      //   },
      //   icon: Icon(Icons.add, color: Colors.white),
      // ),
      // appBar: HikeeAppBar(
      //   elevation: 0,
      //   title: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //     child: Row(
      //       children: [
      //         Expanded(
      //           child: TextInput(
      //             textEditingController: _searchController,
      //             hintText: 'Search...',
      //             textInputAction: TextInputAction.search,
      //             icon: Icon(Icons.search),
      //             onSubmitted: (q) {
      //               context.read<TopicsProvider>().query = q;
      //             },
      //           ),
      //         ),
      //         SizedBox(
      //           width: 8,
      //         ),
      //         // SizedBox(
      //         //   width: 120,
      //         //   child: Button(
      //         //     backgroundColor: Color(0xFFF5F5F5),
      //         //     child: Selector<TopicsProvider, Tuple2<TopicSortable, Order>>(
      //         //       selector: (_, p) => Tuple2(p.sort, p.order),
      //         //       builder: (_, sortAndOrder, __) => Row(
      //         //         children: [
      //         //           sortAndOrder.item2 == Order.DESC
      //         //               ? Icon(Icons.sort)
      //         //               : Transform.rotate(
      //         //                   angle: 180 * pi / 180, child: Icon(Icons.sort)),
      //         //           Expanded(
      //         //             child: Center(
      //         //               child: Text(
      //         //                 sortAndOrder.item1.name,
      //         //                 style: TextStyle(
      //         //                     color: Theme.of(context)
      //         //                         .textTheme
      //         //                         .bodyText1!
      //         //                         .color),
      //         //               ),
      //         //             ),
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //     onPressed: () {
      //         //       _showSortMenu();
      //         //     },
      //         //   ),
      //         // ),
      //       ],
      //     ),
      //   ),
      // ),
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 76.0,
            collapsedHeight: 60.0,
            pinned: true,
            elevation: 2,
            backgroundColor: Colors.white,
            flexibleSpace: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextInput(
                      textEditingController: _searchController,
                      hintText: 'Search...',
                      textInputAction: TextInputAction.search,
                      icon: Icon(Icons.search),
                      onSubmitted: (q) {
                        context.read<TopicsProvider>().query = q;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: Row(
          //       children: [Text('test')],
          //     ),
          //   ),
          // ),
          SliverList(
              delegate: SliverChildListDelegate([
            InfiniteScroller<Topic>(
                controller: controller,
                shrinkWrap: true,
                separator: SizedBox(
                  height: 16,
                ),
                padding:
                    EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                builder: (topic) {
                  return TopicTile(
                    topic: topic,
                    onTap: () {
                      Routemaster.of(context).push('/topics/${topic.id}');
                    },
                  );
                })
          ]))
        ],
      ),
      // body: SafeArea(
      //   child: Container(
      //     color: Colors.white,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Expanded(
      //           child: InfiniteScroller<Topic>(
      //               controller: Get.find<TopicsController>(),
      //               separator: SizedBox(
      //                 height: 16,
      //               ),
      //               builder: (topic) {
      //                 return TopicTile(
      //                   topic: topic,
      //                   onTap: () {
      //                     Routemaster.of(context).push('/topics/${topic.id}');
      //                   },
      //                 );
      //               }),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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