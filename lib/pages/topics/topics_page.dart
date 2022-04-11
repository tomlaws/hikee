import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/topics/topic_tile.dart';
import 'package:hikees/models/topic.dart';
import 'package:hikees/pages/search/search_page.dart';
import 'package:hikees/pages/topics/topics_controller.dart';

class TopicsPage extends GetView<TopicsController> {
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
                leading: Button(
                  icon: Icon(Icons.add),
                  secondary: true,
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    Get.toNamed('/topics/create', arguments: {
                      //'categoryId': categoriesController.currentCategory.value
                    });
                  },
                ),
                actions: [
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
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('topics'.tr),
                )),
          ),
          list
        ],
      ),
    );
  }
}
